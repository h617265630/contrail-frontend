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
from app.models.resources.link import LinkResource
from app.models.user_resource import UserResource
from app.models.category import Category


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

                return {
                    "title": title,
                    "description": description,
                    "thumbnail_url": thumbnail_url,
                    "author": None,
                    "publish_date": None,
                    "video_id": None,
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

        # 1) Try pytube first (richer: description/publish_date).
        try:
            yt = YouTube(url)
            title = (yt.title or "").strip()
            description = (yt.description or "").strip() or None
            thumbnail_url = (yt.thumbnail_url or "").strip() or None
            author = (getattr(yt, "author", "") or "").strip() or None
            publish_date = getattr(yt, "publish_date", None)
            chapters = ResourceCURD._parse_chapters_from_description(description)
            if not title:
                raise ValueError("Extraction failed: missing title")

            meta = {
                "title": title,
                "description": description,
                "thumbnail_url": thumbnail_url,
                "author": author,
                "publish_date": publish_date,
                "video_id": video_id,
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
            meta = {
                "title": oembed["title"],
                "description": None,
                "thumbnail_url": oembed.get("thumbnail_url"),
                "author": oembed.get("author"),
                "publish_date": None,
                "video_id": video_id,
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
            "thumbnail_url": f"https://i.ytimg.com/vi/{video_id}/hqdefault.jpg",
            "author": None,
            "publish_date": None,
            "video_id": video_id,
            "chapters": [],
        }
        if key:
            ResourceCURD._extract_cache[key] = (time.time(), meta)
        return meta

    @staticmethod
    def _get_or_create_link_resource(
        db: Session,
        *,
        url: str,
        title: str,
        description: Optional[str],
        thumbnail_url: Optional[str],
        source: Optional[str],
        category: Optional[str],
    ) -> LinkResource:
        existing = db.query(LinkResource).filter(LinkResource.url == url).first()
        if existing:
            # update lightweight fields if missing
            if not existing.title:
                existing.title = title
            if description and not existing.description:
                existing.description = description
            if thumbnail_url and not existing.thumbnail_url:
                existing.thumbnail_url = thumbnail_url
            if source and not existing.source:
                existing.source = source
            if category and not existing.category:
                existing.category = category
            db.add(existing)
            db.flush()
            return existing

        resource = LinkResource(
            title=title,
            description=description,
            resource_type=LinkResource.__mapper_args__["polymorphic_identity"],
            # User-created resources should not automatically become public.
            is_public=False,
            url=url,
            source=source,
            category=category,
            thumbnail_url=thumbnail_url,
        )
        db.add(resource)
        db.flush()
        return resource

    @staticmethod
    def attach_to_user(db: Session, *, user_id: int, resource_id: int) -> None:
        hit = (
            db.query(UserResource)
            .filter(UserResource.user_id == user_id, UserResource.resource_id == resource_id)
            .first()
        )
        if hit:
            return
        db.add(UserResource(user_id=user_id, resource_id=resource_id))
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
    def list_public(db: Session) -> list[Resource]:
        from app.models.resources.link import LinkResource
        return db.query(LinkResource).filter(LinkResource.is_public.is_(True)).order_by(LinkResource.id.desc()).all()

    @staticmethod
    def create_from_url(
        db: Session,
        *,
        user_id: int,
        url: str,
        category: Optional[str] = None,
        category_id: int | None = None,
    ) -> Resource:
        meta = ResourceCURD.extract_from_url(url)
        source = (urlparse(url).hostname or "").lower().removeprefix("www.") or None

        if category_id is not None:
            hit = db.query(Category).filter(Category.id == category_id).first()
            if not hit:
                raise ValueError("Category not found")

        link = ResourceCURD._get_or_create_link_resource(
            db,
            url=url,
            title=meta["title"],
            description=meta["description"],
            thumbnail_url=meta["thumbnail_url"],
            source=source,
            category=category or "Other",
        )

        # Associate to categories table (new FK) but keep legacy string category as-is.
        if category_id is not None:
            link.category_id = category_id

        ResourceCURD.attach_to_user(db, user_id=user_id, resource_id=link.id)
        return link

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
        url: Optional[str] = None,
        title: Optional[str] = None,
        description: Optional[str] = None,
        is_public: Optional[bool] = None,
        category_id: int | None = None,
    ) -> Resource:
        items = ResourceCURD.list_for_user(db, user_id=user_id)
        obj = next((r for r in items if r.id == resource_id), None)
        if not obj:
            raise ValueError("resource not found")

        current_url = getattr(obj, "url", None)
        next_url = (url or "").strip() or None
        if next_url and next_url != current_url:
            # url 在 link_resources 上有 unique 约束。
            # 这里用 create_from_url 走“按 url 复用/创建资源 + 重新挂载用户”的流程，
            # 然后把旧关联解绑（必要时会触发旧资源清理）。
            category = getattr(obj, "category", None)
            new_obj = ResourceCURD.create_from_url(db, user_id=user_id, url=next_url, category=category)
            ResourceCURD.detach_from_user(db, user_id=user_id, resource_id=resource_id)
            obj = new_obj

        if title is not None:
            t = title.strip()
            if not t:
                raise ValueError("title cannot be empty")
            obj.title = t

        if description is not None:
            d = description.strip()
            obj.description = d or None

        if is_public is not None:
            obj.is_public = bool(is_public)

        if category_id is not None:
            hit = db.query(Category).filter(Category.id == category_id).first()
            if not hit:
                raise ValueError("Category not found")
            obj.category_id = category_id

        db.add(obj)
        db.flush()
        return obj
