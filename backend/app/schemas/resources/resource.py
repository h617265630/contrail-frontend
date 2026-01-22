from datetime import datetime
from typing import Any, Optional

from pydantic import BaseModel, ConfigDict, HttpUrl


class ResourceCreateFromUrl(BaseModel):
    url: HttpUrl
    category_id: int
    model_config = ConfigDict(from_attributes=True)


class ResourceUpdateRequest(BaseModel):
    title: Optional[str] = None
    summary: Optional[str] = None
    platform: Optional[str] = None
    thumbnail: Optional[str] = None
    category_id: Optional[int] = None
    difficulty: Optional[int] = None
    tags: Optional[dict[str, Any]] = None
    raw_meta: Optional[dict[str, Any]] = None
    model_config = ConfigDict(from_attributes=True)


class VideoInfo(BaseModel):
    duration: Optional[int] = None
    channel: Optional[str] = None
    video_id: Optional[str] = None
    model_config = ConfigDict(from_attributes=True)


class DocInfo(BaseModel):
    doc_type: Optional[str] = None
    version: Optional[str] = None
    model_config = ConfigDict(from_attributes=True)


class ArticleInfo(BaseModel):
    publisher: Optional[str] = None
    published_at: Optional[datetime] = None
    model_config = ConfigDict(from_attributes=True)


class ResourceResponse(BaseModel):
    id: int
    resource_type: str
    platform: Optional[str] = None
    title: str
    summary: Optional[str] = None
    source_url: str
    thumbnail: Optional[str] = None
    category_id: int
    category_name: Optional[str] = None
    difficulty: Optional[int] = None
    tags: Optional[dict[str, Any]] = None
    raw_meta: Optional[dict[str, Any]] = None

    created_at: Optional[datetime] = None
    model_config = ConfigDict(from_attributes=True)


class ResourceDetailResponse(ResourceResponse):
    video: Optional[VideoInfo] = None
    doc: Optional[DocInfo] = None
    article: Optional[ArticleInfo] = None


class ResourceAttachResponse(BaseModel):
    already_exists: bool
    resource: ResourceResponse

    model_config = ConfigDict(from_attributes=True)
