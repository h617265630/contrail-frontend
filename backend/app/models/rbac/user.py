from sqlalchemy import Column, Integer, String,DateTime,Boolean,Text
from sqlalchemy.orm import relationship
from app.db.database import Base
from datetime import datetime

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True, nullable=False)
    email = Column(String(120), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    display_name = Column(String(100))
    avatar_url = Column(String(500))
    bio = Column(Text)
    created_at = Column(DateTime,default=datetime.now)
    updated_at = Column(DateTime,default=datetime.now,onupdate=datetime.now)
    is_active = Column(Boolean, default=1)  # 1 for active, 0 for inactive
    is_superuser = Column(Boolean, default=False)  # 1 for superuser, 0 for regular user
    
    #relationships
    videos = relationship("Video",secondary="user_video",back_populates="users")

    user_resources = relationship("UserResource", back_populates="user", cascade="all, delete-orphan")
   
    user_videos = relationship("UserVideo", back_populates="user", cascade="all, delete-orphan")
    learning_paths = relationship("LearningPath", back_populates="users", secondary="user_learning_paths")
    

    watch_history = relationship("WatchHistory", back_populates="user", cascade="all, delete-orphan")
    # 删除无定义的 UserItemLike 关系，避免映射初始化失败
    # likes = relationship("UserItemLike", back_populates="user")

    # 多对多：用户-角色（通过关联表 user_roles）
    roles = relationship(
        "Role",
        secondary="user_roles",
        back_populates="users"
    )
    # 关联对象集合：User 与 UserRole 的一对多（访问带审计字段的关联记录）
    user_roles = relationship("UserRole", back_populates="user", cascade="all, delete-orphan")
  
    # 用户-视频点赞集合（与 relations.UserVideoLike 匹配）
    video_likes = relationship("UserVideoLike", back_populates="user", cascade="all, delete-orphan")
    #learning_paths
    #permissions
    def to_dict(self):
        return {
            "id": self.id,
            "username": self.username,
            "email": self.email,
            "display_name": self.display_name,
            "avatar_url": self.avatar_url,
            "bio": self.bio,
            "is_active": self.is_active,
            "is_superuser": self.is_superuser,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
            "roles": [getattr(role, "code", None) for role in self.roles] if self.roles else []
        }
    
    def has_role(self, role_code: str) -> bool:
        """检查用户是否有指定角色"""
        if self.is_superuser:
            return True
        return any(role.code == role_code for role in self.roles)
    
    def has_permission(self, permission_code: str) -> bool:
        """检查用户是否有指定权限"""
        if self.is_superuser:
            return True
        
        for role in self.roles:
            for permission in role.permissions:
                if permission.code == permission_code:
                    return True
        return False
    
    def get_all_permissions(self) -> list:
        """获取用户所有权限"""
        if self.is_superuser:
            return ["*"]  # 超级管理员拥有所有权限
        
        permissions = set()
        for role in self.roles:
            for permission in role.permissions:
                permissions.add(permission.code)
        return list(permissions)

    def __repr__(self):
        return f"<User(id={self.id}, username={self.username}, email={self.email})>"
    



    @property
    def video_count(self):
        return len(self.videos)


