### 根据字段，id,title,description,file_path,file_size,duration,uploader_id,uploaded_time,status,category_id,生成一个Video模型的示例代码
from sqlalchemy import Column, Integer, String,Boolean, Text, DateTime, ForeignKey, Float 
from sqlalchemy.orm import relationship
from app.models.video_category import VideoCategory
from app.models.resource import Resource, ResourceType
# from app.db.database import Base

class Video(Resource):
    __tablename__ = "videos"
    id = Column(Integer, ForeignKey('resources.id'), primary_key=True)
    file_size = Column(Integer, nullable=False)  # in bytes
    file_path = Column(String(500), nullable=False)
    thumbnail_path = Column(String(500))
    duration = Column(Float, nullable=False)  # in seconds
    view_count = Column(Integer, default=0)
    #relationships
    # 使用明确的关联表对象，避免因导入顺序导致的表名解析错误
    categories = relationship("Category", secondary=VideoCategory.__table__, back_populates="videos")
    users = relationship("User", secondary="user_video", back_populates="videos")

    user_videos = relationship("UserVideo", back_populates="video", cascade="all, delete-orphan")
    watch_history = relationship("WatchHistory", back_populates="video", cascade="all, delete-orphan")
    # 用户-视频点赞集合（与 relations.UserVideoLike 匹配）
    user_likes = relationship("UserVideoLike", back_populates="video", cascade="all, delete-orphan")

    __mapper_args__ = {
        'polymorphic_identity': ResourceType.VIDEO,
    }
    def __repr__(self):
        return f"<Video(id={self.id})>"
