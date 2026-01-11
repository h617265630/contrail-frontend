from __future__ import annotations

from typing import Optional
from urllib.parse import urlparse
import re

from sqlalchemy.orm import Session

from pytube import YouTube

from app.models.resource import Resource
from app.models.resources.link import LinkResource
from app.models.user_resource import UserResource


class ResourceCURD:
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
    def extract_from_url(url: str) -> dict:
        if not ResourceCURD._is_youtube(url):
            raise ValueError("Only YouTube URLs are supported for extraction")

        yt = YouTube(url)
        title = (yt.title or "").strip()
        description = (yt.description or "").strip() or None
        thumbnail_url = (yt.thumbnail_url or "").strip() or None
        author = (getattr(yt, "author", "") or "").strip() or None
        publish_date = getattr(yt, "publish_date", None)
        video_id = ResourceCURD._youtube_video_id(url)
        chapters = ResourceCURD._parse_chapters_from_description(description)
        if not title:
            raise ValueError("Extraction failed: missing title")

        return {
            "title": title,
            "description": description,
            "thumbnail_url": thumbnail_url,
            "author": author,
            "publish_date": publish_date,
            "video_id": video_id,
            "chapters": chapters,
        }

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
    def create_from_url(db: Session, *, user_id: int, url: str, category: Optional[str] = None) -> Resource:
        meta = ResourceCURD.extract_from_url(url)
        source = (urlparse(url).hostname or "").lower().removeprefix("www.") or None

        link = ResourceCURD._get_or_create_link_resource(
            db,
            url=url,
            title=meta["title"],
            description=meta["description"],
            thumbnail_url=meta["thumbnail_url"],
            source=source,
            category=category or "Other",
        )
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

        remaining = db.query(UserResource).filter(UserResource.resource_id == resource_id).count()
        if remaining == 0:
            obj = db.query(Resource).filter(Resource.id == resource_id).first()
            if obj:
                db.delete(obj)
                db.flush()
