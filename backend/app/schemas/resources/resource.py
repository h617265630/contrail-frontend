from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, HttpUrl

from app.schemas.resources.extract import ChapterItem


class ResourceCreateFromUrl(BaseModel):
    url: HttpUrl
    category: Optional[str] = None
    model_config = ConfigDict(from_attributes=True)


class ResourceResponse(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    resource_type: str

    url: Optional[str] = None
    source: Optional[str] = None
    category: Optional[str] = None
    thumbnail_url: Optional[str] = None

    created_at: Optional[datetime] = None
    model_config = ConfigDict(from_attributes=True)


class ResourceDetailResponse(ResourceResponse):
    author: Optional[str] = None
    publish_date: Optional[datetime] = None
    video_id: Optional[str] = None
    chapters: list[ChapterItem] = []
