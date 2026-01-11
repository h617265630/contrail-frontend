from sqlalchemy import Column, DateTime, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import relationship
from datetime import datetime

from app.db.database import Base


class UserResource(Base):
    __tablename__ = "user_resource"

    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    resource_id = Column(Integer, ForeignKey("resources.id"), primary_key=True)
    created_at = Column(DateTime, default=datetime.now)

    user = relationship("User", back_populates="user_resources")
    resource = relationship("Resource", back_populates="user_resources")

    __table_args__ = (
        UniqueConstraint("user_id", "resource_id", name="uq_user_resource"),
    )
