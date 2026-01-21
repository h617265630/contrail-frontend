from datetime import date, datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, HttpUrl

from app.schemas.resources.extract import ChapterItem


class ResourceCreateFromUrl(BaseModel):
    url: HttpUrl
    category: Optional[str] = None
    category_id: Optional[int] = None
    model_config = ConfigDict(from_attributes=True)


class ResourceUpdateRequest(BaseModel):
    url: Optional[HttpUrl] = None
    title: Optional[str] = None
    description: Optional[str] = None
    is_public: Optional[bool] = None
    category_id: Optional[int] = None
    model_config = ConfigDict(from_attributes=True)


class ResourceResponse(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    resource_type: str
    # Raw resource type stored in DB (video/clip/link). Frontend should use this
    # when interacting with learning-path item APIs.
    resource_kind: Optional[str] = None

    is_public: bool = True

    url: Optional[str] = None
    source: Optional[str] = None
    category: Optional[str] = None
    category_id: Optional[int] = None
    category_name: Optional[str] = None
    thumbnail_url: Optional[str] = None

    created_at: Optional[datetime] = None
    model_config = ConfigDict(from_attributes=True)


class ResourceDetailResponse(ResourceResponse):
    author: Optional[str] = None
    publish_date: Optional[date] = None
    video_id: Optional[str] = None
    chapters: list[ChapterItem] = []


class ResourceAttachResponse(BaseModel):
    already_exists: bool
    resource: ResourceResponse

    model_config = ConfigDict(from_attributes=True)
