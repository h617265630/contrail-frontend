from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from app.models.learning_path import LearningPath
from app.models.user_learning_path import UserLearningPath
from app.models.path_item import PathItem
from app.models.resource import Resource, ResourceType
class LearningPathCURD:
    @staticmethod
    def create_learning_path(db: Session, user_id: int, title: str, description: str = None) -> LearningPath:
        learning_path = LearningPath(title=title, description=description)
        db.add(learning_path)
        db.commit()
        db.refresh(learning_path)

        # 创建关联记录
        user_learning_path = UserLearningPath(user_id=user_id, learning_path_id=learning_path.id)
        try:
            db.add(user_learning_path)
            db.commit()
        except Exception:
            db.rollback()
            raise Exception("This learning path is already associated with the user.")

        return learning_path
    
    @staticmethod
    def get_learning_paths_by_user(db: Session, user_id: int, skip: int = 0, limit: int = 100) -> List[LearningPath]:
        learning_paths = (
            db.query(LearningPath)
            .join(UserLearningPath, UserLearningPath.learning_path_id == LearningPath.id)
            .filter(UserLearningPath.user_id == user_id)
            .offset(skip)
            .limit(limit)
            .all()
        )
        return learning_paths
    

    @staticmethod
    def get_learning_path(db: Session, learning_path_id: int) -> Optional[LearningPath]:
        return db.query(LearningPath).filter(LearningPath.id == learning_path_id).first()
    


    
    @staticmethod
    def delete_learning_path(db: Session, learning_path: LearningPath) -> None:
        db.delete(learning_path)
        db.commit() 

    # ---------- PathItem 相关 CRUD ----------  还要修改
    @staticmethod
    def add_resource_to_learning_path(
        db: Session,
        learning_path_id: int,
        resource_id: int,
        resource_type: ResourceType | str,
        *,
        title: Optional[str] = None,
        description: Optional[str] = None,
        position: Optional[int] = None,
    ) -> PathItem:
        # 校验学习路径存在
        lp = db.query(LearningPath).filter(LearningPath.id == learning_path_id).first()
        if not lp:
            raise ValueError("LearningPath not found")

        # 允许 resource_type 传入字符串（例如 "video"/"clip"）
        if isinstance(resource_type, str):
            try:
                resource_type = ResourceType(resource_type)
            except Exception:
                raise ValueError("Invalid resource_type")

        # 校验资源存在且类型匹配
        res = db.query(Resource).filter(Resource.id == resource_id).first()
        if not res:
            raise ValueError("Resource not found")
        if res.resource_type != resource_type:
            raise ValueError("Resource type mismatch")

        # 计算 position（若未提供，则取该路径现有最大 position + 1）
        if position is None:
            max_pos = (
                db.query(PathItem.position)
                .filter(PathItem.learning_path_id == learning_path_id)
                .order_by(PathItem.position.desc())
                .first()
            )
            position = (max_pos[0] + 1) if max_pos else 1

        # 如果未提供标题，默认用资源的标题（Resource 有 title 字段）
        if title is None:
            title = getattr(res, "title", f"Resource {res.id}")

        item = PathItem(
            learning_path_id=learning_path_id,
            resource_id=resource_id,
            title=title,
            resource_type=resource_type.value,
            position=position,
            description=description,
        )
        db.add(item)
        db.commit()
        db.refresh(item)
        return item

    @staticmethod
    def remove_resource_from_learning_path(
        db: Session,
        learning_path_id: int,
        resource_id: int,
    ) -> bool:
        item = (
            db.query(PathItem)
            .filter(
                PathItem.learning_path_id == learning_path_id,
                PathItem.resource_id == resource_id,
            )
            .first()
        )
        if not item:
            return False
        db.delete(item)
        db.commit()
        return True

    @staticmethod
    def get_learning_path_with_items(
        db: Session, learning_path_id: int
    ) -> Optional[LearningPath]:
        # 预加载 path_items 以及资源对象，按照 position 排序
        lp = (
            db.query(LearningPath)
            .options(
                joinedload(LearningPath.path_items).joinedload(PathItem.resource)
            )
            .filter(LearningPath.id == learning_path_id)
            .first()
        )
        return lp

    # 语义化封装：注册 clip/video 为 pathitem
    @staticmethod
    def register_clip(
        db: Session,
        learning_path_id: int,
        clip_id: int,
        **kwargs,
    ) -> PathItem:
        return LearningPathCURD.add_resource_to_learning_path(
            db,
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
        return LearningPathCURD.add_resource_to_learning_path(
            db,
            learning_path_id=learning_path_id,
            resource_id=video_id,
            resource_type=ResourceType.VIDEO,
            **kwargs,
        )