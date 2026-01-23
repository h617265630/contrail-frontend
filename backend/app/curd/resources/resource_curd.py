from __future__ import annotations

from typing import Optional
from urllib.parse import urlparse
from html import unescape
import re
import time

import httpx

from sqlalchemy.orm import Session

from pytube import YouTube

from app.models.resource import Resource
from app.models.category import Category
from app.models.resources.video import Video
from app.models.resources.doc import Doc
from app.models.resources.article import Article
from app.models.user_resource import UserResource


class ResourceCURD:
    # Best-effort in-process cache for extraction results.
    # This dramatically reduces latency for repeated opens of the same resource detail.
    _EXTRACT_CACHE_TTL_SECONDS = 10 * 60
    _extract_cache: dict[str, tuple[float, dict]] = {}

    @staticmethod
    def _youtube_video_id(url: str) -> Optional[str]:
        try:
            parsed = urlparse(url)
        except Exception:
            return None

        host = (parsed.hostname or "").lower()
        if host.endswith("youtu.be"):
            vid = (parsed.path or "").lstrip("/")
            return vid or None

        # youtube.com/watch?v=...
        if host.endswith("youtube.com"):
            qs = parsed.query or ""
            m = re.search(r"(?:^|&)v=([^&]+)", qs)
            if m:
                return m.group(1)
            # fallback: /embed/{id}
            parts = [p for p in (parsed.path or "").split("/") if p]
            if len(parts) >= 2 and parts[0] in {"embed", "shorts"}:
                return parts[1]
        return None

    @staticmethod
    def _youtube_thumbnail(video_id: str | None) -> str | None:
        if not video_id:
            return None
        vid = (video_id or "").strip()
        if not vid:
            return None
        return f"https://i.ytimg.com/vi/{vid}/hqdefault.jpg"

    @staticmethod
    def _parse_chapters_from_description(description: Optional[str]) -> list[dict]:
        if not description:
            return []

        # Common patterns:
        # 00:00 Intro
        # 0:00 - Intro
        # 1:02:03 Chapter name
        ts_re = re.compile(
            r"^(?P<ts>(?:\d{1,2}:)?\d{1,2}:\d{2})\s*(?:[-–—]|\)|\]|\s)\s*(?P<title>.+?)\s*$"
        )

        def to_seconds(ts: str) -> int:
            parts = [int(p) for p in ts.split(":")]
            if len(parts) == 2:
                mm, ss = parts
                return mm * 60 + ss
            if len(parts) == 3:
                hh, mm, ss = parts
                return hh * 3600 + mm * 60 + ss
            return 0

        chapters: list[dict] = []
        for raw_line in description.splitlines():
            line = raw_line.strip()
            if not line:
                continue
            m = ts_re.match(line)
            if not m:
                continue
            ts = m.group("ts")
            title = m.group("title").strip()
            if not title:
                continue
            chapters.append(
                {
                    "start_seconds": to_seconds(ts),
                    "timestamp": ts,
                    "title": title,
                    "description": None,
                }
            )

        # De-dup & sort by time
        seen = set()
        uniq: list[dict] = []
        for ch in sorted(chapters, key=lambda x: x["start_seconds"]):
            key = (ch["start_seconds"], ch["title"].lower())
            if key in seen:
                continue
            seen.add(key)
            uniq.append(ch)
        return uniq

    @staticmethod
    def _is_youtube(url: str) -> bool:
        host = (urlparse(url).hostname or "").lower()
        return host.endswith("youtube.com") or host.endswith("youtu.be")

    @staticmethod
    def _normalize_platform(host: str | None, site_name: str | None = None) -> str | None:
        raw_host = (host or "").lower().removeprefix("www.")
        if not raw_host and site_name:
            raw_host = site_name.strip().lower().replace(" ", "")

        # Normalize common platforms
        if raw_host.endswith("bilibili.com"):
            return "bilibili"
        if raw_host.endswith("xiaohongshu.com") or raw_host.endswith("xhslink.com"):
            return "xiaohongshu"
        if raw_host.endswith("medium.com"):
            return "medium"
        if raw_host.endswith("reddit.com"):
            return "reddit"
        if raw_host.endswith("github.com"):
            return "github"
        if raw_host.endswith("substack.com"):
            return "substack"

        return raw_host or None

    @staticmethod
    def _infer_resource_type(url: str, meta: dict) -> str:
        raw = (url or "").strip()
        base = raw.lower().split("?", 1)[0]
        if base.endswith(".pdf"):
            return "document"

        host = (urlparse(raw).hostname or "").lower().removeprefix("www.")

        # Known video platforms
        if ResourceCURD._is_youtube(raw):
            return "video"
        if host.endswith("bilibili.com"):
            return "video"
        if host.endswith("xiaohongshu.com") or host.endswith("xhslink.com"):
            # xiaohongshu links can be video or图文; default video for better UX
            return "video"

        og_type = str(meta.get("og_type") or "").strip().lower()
        if og_type.startswith("video"):
            return "video"

        # If page provides an embeddable player, treat as video
        if meta.get("og_video") or meta.get("twitter_player"):
            return "video"

        # GitHub is usually docs/technical content
        if host.endswith("github.com"):
            return "document"

        # Default
        return "article"

    @staticmethod
    def _guess_title_from_url(url: str) -> str:
        try:
            parsed = urlparse(url)
            host = (parsed.hostname or "").strip() or ""
            path = (parsed.path or "").strip() or ""
            name = (path.rsplit("/", 1)[-1] or "").strip()
            if name:
                return unescape(name)
            return host or "Link"
        except Exception:
            return "Link"

    @staticmethod
    def _extract_generic_url(url: str) -> dict:
        """Best-effort metadata extraction for non-YouTube links."""
        raw = (url or "").strip()
        if not raw:
            raise ValueError("Invalid URL")

        # Try a lightweight fetch to infer title/description/thumbnail.
        try:
            with httpx.Client(timeout=8.0, follow_redirects=True, headers={"User-Agent": "Mozilla/5.0"}) as client:
                resp = client.get(raw)
                resp.raise_for_status()
                content_type = (resp.headers.get("content-type") or "").lower()

                # PDF or binary: no HTML parsing.
                if "application/pdf" in content_type or raw.lower().split("?", 1)[0].endswith(".pdf"):
                    return {
                        "title": ResourceCURD._guess_title_from_url(raw),
                        "description": None,
                        "thumbnail_url": None,
                        "author": None,
                        "publish_date": None,
                        "video_id": None,
                        "duration_seconds": None,
                        "platform": (urlparse(raw).hostname or "").lower().removeprefix("www.") or None,
                        "chapters": [],
                    }

                text = resp.text or ""

                def _find_title(html: str) -> str | None:
                    m = re.search(r"<title[^>]*>(?P<t>.*?)</title>", html, flags=re.IGNORECASE | re.DOTALL)
                    if not m:
                        return None
                    t = re.sub(r"\s+", " ", m.group("t") or "").strip()
                    return unescape(t) if t else None

                def _find_meta(html: str, *, name: str | None = None, prop: str | None = None) -> str | None:
                    if name:
                        m = re.search(
                            rf"<meta[^>]+name=['\"]{re.escape(name)}['\"][^>]+content=['\"](?P<c>[^'\"]+)['\"][^>]*>",
                            html,
                            flags=re.IGNORECASE,
                        )
                        if m:
                            return unescape((m.group("c") or "").strip()) or None
                    if prop:
                        m = re.search(
                            rf"<meta[^>]+property=['\"]{re.escape(prop)}['\"][^>]+content=['\"](?P<c>[^'\"]+)['\"][^>]*>",
                            html,
                            flags=re.IGNORECASE,
                        )
                        if m:
                            return unescape((m.group("c") or "").strip()) or None
                    return None

                title = _find_title(text) or _find_meta(text, prop="og:title") or ResourceCURD._guess_title_from_url(raw)
                description = _find_meta(text, name="description") or _find_meta(text, prop="og:description")
                thumbnail_url = _find_meta(text, prop="og:image")
                platform = _find_meta(text, prop="og:site_name")

                og_type = _find_meta(text, prop="og:type")
                og_video = _find_meta(text, prop="og:video") or _find_meta(text, prop="og:video:url")
                twitter_player = _find_meta(text, name="twitter:player")

                if platform:
                    platform = platform.strip() or None
                host = (urlparse(raw).hostname or "").lower().removeprefix("www.") or None
                platform = ResourceCURD._normalize_platform(host, platform)

                return {
                    "title": title,
                    "description": description,
                    "thumbnail_url": thumbnail_url,
                    "author": None,
                    "publish_date": None,
                    "video_id": None,
                    "duration_seconds": None,
                    "platform": platform,
                    "og_type": og_type,
                    "og_video": og_video,
                    "twitter_player": twitter_player,
                    "chapters": [],
                }
        except Exception:
            # Final fallback: deterministic meta so UX can proceed.
            return {
                "title": ResourceCURD._guess_title_from_url(raw),
                "description": None,
                "thumbnail_url": None,
                "author": None,
                "publish_date": None,
                "video_id": None,
                "duration_seconds": None,
                "platform": (urlparse(raw).hostname or "").lower().removeprefix("www.") or None,
                "chapters": [],
            }

    @staticmethod
    def _extract_youtube_oembed(url: str) -> dict:
        """Best-effort metadata via YouTube oEmbed (no API key).

        Returns a partial meta dict: title, author, thumbnail_url.
        Raises on failure.
        """
        params = {"url": url, "format": "json"}
        with httpx.Client(timeout=8.0, follow_redirects=True) as client:
            resp = client.get("https://www.youtube.com/oembed", params=params)
            resp.raise_for_status()
            data = resp.json()

        title = (data.get("title") or "").strip()
        author = (data.get("author_name") or "").strip() or None
        thumbnail_url = (data.get("thumbnail_url") or "").strip() or None
        if not title:
            raise ValueError("Extraction failed: missing title")
        return {"title": title, "author": author, "thumbnail_url": thumbnail_url}

    @staticmethod
    def extract_from_url(url: str) -> dict:
        key = (url or "").strip()
        if key:
            cached = ResourceCURD._extract_cache.get(key)
            if cached:
                ts, meta = cached
                if (time.time() - ts) < ResourceCURD._EXTRACT_CACHE_TTL_SECONDS:
                    return meta

        if not ResourceCURD._is_youtube(url):
            meta = ResourceCURD._extract_generic_url(url)
            if key:
                ResourceCURD._extract_cache[key] = (time.time(), meta)
            return meta

        video_id = ResourceCURD._youtube_video_id(url)
        if not video_id:
            raise ValueError("Invalid YouTube URL")

        # 1) Try pytube first (richer: description/publish_date/duration).
        try:
            yt = YouTube(url)
            title = (yt.title or "").strip()
            description = (yt.description or "").strip() or None
            thumbnail_url = (yt.thumbnail_url or "").strip() or None
            author = (getattr(yt, "author", "") or "").strip() or None
            publish_date = getattr(yt, "publish_date", None)
            duration_seconds = getattr(yt, "length", None)
            try:
                duration_seconds = int(duration_seconds) if duration_seconds is not None else None
            except Exception:
                duration_seconds = None
            if duration_seconds is not None and duration_seconds < 0:
                duration_seconds = None
            chapters = ResourceCURD._parse_chapters_from_description(description)
            if not title:
                raise ValueError("Extraction failed: missing title")

            if not thumbnail_url:
                thumbnail_url = ResourceCURD._youtube_thumbnail(video_id)

            meta = {
                "title": title,
                "description": description,
                "thumbnail_url": thumbnail_url,
                "author": author,
                "publish_date": publish_date,
                "video_id": video_id,
                "duration_seconds": duration_seconds,
                "platform": "youtube",
                "chapters": chapters,
            }
            if key:
                ResourceCURD._extract_cache[key] = (time.time(), meta)
            return meta
        except Exception:
            pass

        # 2) Fallback to oEmbed (usually more stable than pytube).
        try:
            oembed = ResourceCURD._extract_youtube_oembed(url)
            thumbnail_url = (oembed.get("thumbnail_url") or "").strip() or None
            if not thumbnail_url:
                thumbnail_url = ResourceCURD._youtube_thumbnail(video_id)
            meta = {
                "title": oembed["title"],
                "description": None,
                "thumbnail_url": thumbnail_url,
                "author": oembed.get("author"),
                "publish_date": None,
                "video_id": video_id,
                "duration_seconds": None,
                "platform": "youtube",
                "chapters": [],
            }
            if key:
                ResourceCURD._extract_cache[key] = (time.time(), meta)
            return meta
        except Exception:
            pass

        # 3) Final fallback: deterministic metadata from video_id so UX can proceed
        # even when outbound access is blocked.
        meta = {
            "title": f"YouTube Video {video_id}",
            "description": None,
            "thumbnail_url": ResourceCURD._youtube_thumbnail(video_id),
            "author": None,
            "publish_date": None,
            "video_id": video_id,
            "duration_seconds": None,
            "platform": "youtube",
            "chapters": [],
        }
        if key:
            ResourceCURD._extract_cache[key] = (time.time(), meta)
        return meta

    @staticmethod
    def attach_to_user(db: Session, *, user_id: int, resource_id: int, is_public: bool = False) -> None:
        hit = (
            db.query(UserResource)
            .filter(UserResource.user_id == user_id, UserResource.resource_id == resource_id)
            .first()
        )
        if hit:
            return
        db.add(UserResource(user_id=user_id, resource_id=resource_id, is_public=is_public))
        db.flush()

    @staticmethod
    def list_for_user(db: Session, *, user_id: int) -> list[Resource]:
        return (
            db.query(Resource)
            .join(UserResource, UserResource.resource_id == Resource.id)
            .filter(UserResource.user_id == user_id)
            .order_by(Resource.id.desc())
            .all()
        )

    @staticmethod
    def list_all(db: Session) -> list[Resource]:
        return db.query(Resource).order_by(Resource.id.desc()).all()

    @staticmethod
    def create_from_url(
        db: Session,
        *,
        user_id: int,
        url: str,
        category_id: int,
        is_system_public: bool = False,
    ) -> Resource:
        meta = ResourceCURD.extract_from_url(url)
        normalized = (url or "").strip()
        if not normalized:
            raise ValueError("Invalid URL")

        if category_id is None:
            raise ValueError("category_id is required")
        cat = db.query(Category).filter(Category.id == category_id).first()
        if not cat:
            raise ValueError("Category not found")

        resource_type = ResourceCURD._infer_resource_type(normalized, meta)

        platform = meta.get("platform")
        if not platform:
            host = (urlparse(normalized).hostname or "").lower().removeprefix("www.")
            platform = ResourceCURD._normalize_platform(host, None)

        # source_url is NOT unique per requirements.
        obj = Resource(
            resource_type=resource_type,
            platform=platform,
            title=meta.get("title") or ResourceCURD._guess_title_from_url(normalized),
            summary=meta.get("description"),
            source_url=normalized,
            thumbnail=meta.get("thumbnail_url"),
            category_id=category_id,
            difficulty=None,
            tags={},
            raw_meta={
                "author": meta.get("author"),
                "publish_date": meta.get("publish_date"),
                "video_id": meta.get("video_id"),
                "duration_seconds": meta.get("duration_seconds"),
                "chapters": meta.get("chapters") or [],
                "og_type": meta.get("og_type"),
                "og_video": meta.get("og_video"),
                "twitter_player": meta.get("twitter_player"),
            },
            is_system_public=is_system_public,
        )
        db.add(obj)
        db.flush()

        if resource_type == "video":
            v = Video(
                resource_id=obj.id,
                duration=meta.get("duration_seconds"),
                channel=meta.get("author"),
                video_id=meta.get("video_id"),
            )
            db.add(v)
            db.flush()
        elif resource_type == "document":
            d = Doc(resource_id=obj.id)
            db.add(d)
            db.flush()
        else:
            a = Article(resource_id=obj.id)
            db.add(a)
            db.flush()

        ResourceCURD.attach_to_user(db, user_id=user_id, resource_id=obj.id, is_public=is_public)
        return obj

    @staticmethod
    def detach_from_user(db: Session, *, user_id: int, resource_id: int) -> None:
        assoc = (
            db.query(UserResource)
            .filter(UserResource.user_id == user_id, UserResource.resource_id == resource_id)
            .first()
        )
        if not assoc:
            raise ValueError("resource not found")

        db.delete(assoc)
        db.flush()

    @staticmethod
    def update_for_user(
        db: Session,
        *,
        user_id: int,
        resource_id: int,
        title: Optional[str] = None,
        summary: Optional[str] = None,
        platform: Optional[str] = None,
        thumbnail: Optional[str] = None,
        category_id: Optional[int] = None,
        difficulty: Optional[int] = None,
        tags: Optional[dict] = None,
        raw_meta: Optional[dict] = None,
    ) -> Resource:
        items = ResourceCURD.list_for_user(db, user_id=user_id)
        obj = next((r for r in items if r.id == resource_id), None)
        if not obj:
            raise ValueError("resource not found")

        if title is not None:
            t = title.strip()
            if not t:
                raise ValueError("title cannot be empty")
            obj.title = t

        if summary is not None:
            obj.summary = summary.strip() or None

        if platform is not None:
            obj.platform = platform.strip() or None

        if thumbnail is not None:
            obj.thumbnail = thumbnail.strip() or None

        if category_id is not None:
            cat = db.query(Category).filter(Category.id == int(category_id)).first()
            if not cat:
                raise ValueError("Category not found")
            obj.category_id = int(category_id)

        if difficulty is not None:
            obj.difficulty = int(difficulty)

        if tags is not None:
            obj.tags = tags

        if raw_meta is not None:
            obj.raw_meta = raw_meta

        db.add(obj)
        db.flush()
        return obj

