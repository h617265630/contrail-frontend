from typing import Optional, Union, List
from enum import Enum
from pydantic import BaseModel

from app.schemas.resources.video import VideoResponse
from app.schemas.resources.clip import ClipResponse
from app.schemas.resources.resource import ResourceResponse


class ResourceKind(str, Enum):
    video = "video"
    clip = "clip"
    link = "link"


class LearningPathBase(BaseModel):
    title: str
    description: Optional[str] = None
    is_public: bool = False
    category_id: Optional[int] = None
    category_name: Optional[str] = None

    model_config = {
        "from_attributes": True
    }


class LearningPathCreate(LearningPathBase):
    # 与 CURD 保持一致，创建时主要使用 title/description
    pass


class LearningPathUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    is_public: Optional[bool] = None
    is_active: Optional[bool] = None
    category_id: Optional[int] = None

    model_config = {
        "from_attributes": True
    }


class PathItemInLearningPathResponse(BaseModel):
    id: int
    learning_path_id: int
    resource_id: int
    resource_type: ResourceKind
    title: str
    position: int
    description: Optional[str] = None
    # 按需返回嵌入的资源详情
    resource_data: Optional[Union[VideoResponse, ClipResponse, ResourceResponse]] = None

    model_config = {
        "from_attributes": True
    }


class LearningPathResponse(LearningPathBase):
    id: int
    is_active: bool = True

    model_config = {
        "from_attributes": True
    }


class LearningPathDetailResponse(LearningPathResponse):
    path_items: List[PathItemInLearningPathResponse] = []

    model_config = {
        "from_attributes": True
    }


class AddResourceToLearningPathRequest(BaseModel):
    resource_type: ResourceKind
    resource_id: int
    title: Optional[str] = None
    description: Optional[str] = None
    position: Optional[int] = None

    model_config = {
        "from_attributes": True
    }


class LearningPathAttachResponse(BaseModel):
    already_exists: bool
    learning_path: LearningPathResponse

    model_config = {
        "from_attributes": True
    }

    