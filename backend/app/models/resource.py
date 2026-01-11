from datetime import datetime

from sqlalchemy import Column, DateTime, Integer, String, Text, Enum, Boolean
from sqlalchemy.orm import relationship
from app.db.database import Base
import enum

class ResourceType(enum.Enum):
    VIDEO = "video"
    CLIP = "clip"
    LINK = "link"

class Resource(Base):
    __tablename__ = "resources"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False)
    resource_type = Column(Enum(ResourceType), nullable=False)  # 资源类型：video 或 clip
    description = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True)

    created_at = Column(DateTime, default=datetime.now)
    updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)
    
    # 关系：Resource 可以关联多个 PathItem
    path_items = relationship("PathItem", back_populates="resource")

    user_resources = relationship("UserResource", back_populates="resource", cascade="all, delete-orphan")

    # 多态配置：基类只声明 polymorphic_on；不设置 polymorphic_identity
    __mapper_args__ = {
        "polymorphic_on": resource_type
    }
    
    def __repr__(self):
        return f"<Resource {self.title} ({self.resource_type})>" 
       
   