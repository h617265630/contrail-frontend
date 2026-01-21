from typing import List, Optional, Tuple

from sqlalchemy.orm import Session
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError

from app.models.path_item import PathItem
from app.models.learning_path import LearningPath
from app.models.resource import Resource, ResourceType


class PathItemCURD:
    """
    PathItem 的基础增删改查，以及基于资源(Video/Clip)的注册封装。
    采用方案B：PathItem 通过 resource_id 引用资源父表(Resource)，并记录 resource_type。
    约束：
      - (learning_path_id, resource_id) 唯一
      - (learning_path_id, position) 唯一
    """

    # ---------- Read ----------
    @staticmethod
    def get(db: Session, path_item_id: int) -> Optional[PathItem]:
        return db.query(PathItem).filter(PathItem.id == path_item_id).first()

    @staticmethod
    def list_by_learning_path(
        db: Session, learning_path_id: int, skip: int = 0, limit: int = 100
    ) -> List[PathItem]:
        return (
            db.query(PathItem)
            .filter(PathItem.learning_path_id == learning_path_id)
            .order_by(PathItem.position.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    # ---------- Create ----------
    @staticmethod
    def _ensure_learning_path_and_resource(
        db: Session, learning_path_id: int, resource_id: int, resource_type: ResourceType | str
    ) -> Tuple[LearningPath, Resource, ResourceType]:
        lp = db.query(LearningPath).filter(LearningPath.id == learning_path_id).first()
        if not lp:
            raise ValueError("LearningPath not found")

        if isinstance(resource_type, str):
            try:
                resource_type = ResourceType(resource_type)
            except Exception:
                raise ValueError("Invalid resource_type")

        res = db.query(Resource).filter(Resource.id == resource_id).first()
        if not res:
            raise ValueError("Resource not found")
        if res.resource_type != resource_type:
            raise ValueError("Resource type mismatch")

        return lp, res, resource_type

    @staticmethod
    def create(
        db: Session,
        learning_path_id: int,
        resource_id: int,
        resource_type: ResourceType | str,
        *,
        title: Optional[str] = None,
        description: Optional[str] = None,
        position: Optional[int] = None,
    ) -> PathItem:
        lp, res, resource_type = PathItemCURD._ensure_learning_path_and_resource(
            db, learning_path_id, resource_id, resource_type
        )

        # 如果没有给 position，使用当前路径的最大 position + 1
        if position is None:
            max_pos = db.query(func.max(PathItem.position)).filter(
                PathItem.learning_path_id == learning_path_id
            ).scalar()
            position = (max_pos or 0) + 1

        item = PathItem(
            learning_path_id=learning_path_id,
            resource_id=resource_id,
            description=description,
            position=position,
        )
        db.add(item)
        try:
            db.commit()
            db.refresh(item)
        except IntegrityError:
            db.rollback()
            # 可能是位置冲突或资源重复添加
            raise ValueError("Duplicate path item: position or resource already exists in this learning path")
        return item

    @staticmethod
    def register_clip(
        db: Session,
        learning_path_id: int,
        clip_id: int,
        **kwargs,
    ) -> PathItem:
        return PathItemCURD.create(
            db=db,
            learning_path_id=learning_path_id,
            resource_id=clip_id,
            resource_type=ResourceType.CLIP,
            **kwargs,
        )

    @staticmethod
    def register_video(
        db: Session,
        learning_path_id: int,
        video_id: int,
        **kwargs,
    ) -> PathItem:
        return PathItemCURD.create(
            db=db,
            learning_path_id=learning_path_id,
            resource_id=video_id,
            resource_type=ResourceType.VIDEO,
            **kwargs,
        )

    # ---------- Update ----------
    @staticmethod
    def update(
        db: Session,
        path_item_id: int,
        *,
        title: Optional[str] = None,
        description: Optional[str] = None,
        position: Optional[int] = None,
    ) -> Optional[PathItem]:
        item = PathItemCURD.get(db, path_item_id)
        if not item:
            return None

        if description is not None:
            item.description = description
        if position is not None:
            item.position = position

        try:
            db.commit()
            db.refresh(item)
        except IntegrityError:
            db.rollback()
            # 可能是 position 冲突
            raise ValueError("Duplicate position in this learning path")
        return item

    # ---------- Delete ----------
    @staticmethod
    def delete(db: Session, path_item_id: int) -> bool:
        item = PathItemCURD.get(db, path_item_id)
        if not item:
            return False
        db.delete(item)
        db.commit()
        return True
