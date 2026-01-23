from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user, get_db_dep
from app.curd.resources.resource_curd import ResourceCURD
from app.models.resource import Resource
from app.models.user_resource import UserResource
from app.schemas.resources.extract import ChapterItem, UrlExtractRequest, UrlExtractResponse
from app.schemas.resources.resource import (
    ArticleInfo,
    DocInfo,
    ResourceAttachResponse,
    ResourceCreateFromUrl,
    ResourceDetailResponse,
    ResourceResponse,
    ResourceUpdateRequest,
    VideoInfo,
)

router = APIRouter(prefix="/resources", tags=["Resources"])


def _resource_type_value(obj: Resource) -> str:
    rt = getattr(obj, "resource_type", None)
    return (rt.value if hasattr(rt, "value") else str(rt or "")).strip().lower()


@router.post("/extract", response_model=UrlExtractResponse)
def extract_from_url(payload: UrlExtractRequest):
    try:
        meta = ResourceCURD.extract_from_url(str(payload.url))
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"解析失败: {e}")

    return UrlExtractResponse(
        title=meta["title"],
        description=meta.get("description"),
        thumbnail_url=meta.get("thumbnail_url"),
        author=meta.get("author"),
        publish_date=meta.get("publish_date"),
        video_id=meta.get("video_id"),
        duration_seconds=meta.get("duration_seconds"),
        platform=meta.get("platform"),
        chapters=[ChapterItem(**c) for c in (meta.get("chapters") or [])],
    )


@router.get("/me/{resource_id}", response_model=ResourceDetailResponse)
def get_my_resource_detail(resource_id: int, db: Session = Depends(get_db_dep), current_user=Depends(get_current_user)):
    obj = (
        db.query(Resource)
        .join(UserResource, UserResource.resource_id == Resource.id)
        .filter(UserResource.user_id == current_user.id, Resource.id == resource_id)
        .first()
    )
    if not obj:
        raise HTTPException(status_code=404, detail="resource not found")

    return ResourceDetailResponse(
        id=obj.id,
        resource_type=_resource_type_value(obj),
        platform=getattr(obj, "platform", None),
        title=obj.title,
        summary=getattr(obj, "summary", None),
        source_url=getattr(obj, "source_url", None),
        thumbnail=getattr(obj, "thumbnail", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(obj, "category_name", None),
        difficulty=getattr(obj, "difficulty", None),
        tags=getattr(obj, "tags", None),
        raw_meta=getattr(obj, "raw_meta", None),
        created_at=getattr(obj, "created_at", None),
        video=VideoInfo.model_validate(obj.video) if getattr(obj, "video", None) else None,
        doc=DocInfo.model_validate(obj.doc) if getattr(obj, "doc", None) else None,
        article=ArticleInfo.model_validate(obj.article) if getattr(obj, "article", None) else None,
    )


@router.get("/me", response_model=list[ResourceResponse])
def list_my_resources(db: Session = Depends(get_db_dep), current_user=Depends(get_current_user)):
    items = ResourceCURD.list_for_user(db, user_id=current_user.id)
    return [
        ResourceResponse(
            id=r.id,
            resource_type=_resource_type_value(r),
            platform=getattr(r, "platform", None),
            title=r.title,
            summary=getattr(r, "summary", None),
            source_url=getattr(r, "source_url", None),
            thumbnail=getattr(r, "thumbnail", None),
            category_id=getattr(r, "category_id", None),
            category_name=getattr(r, "category_name", None),
            difficulty=getattr(r, "difficulty", None),
            tags=getattr(r, "tags", None),
            raw_meta=getattr(r, "raw_meta", None),
            created_at=getattr(r, "created_at", None),
        )
        for r in items
    ]


@router.get("", response_model=list[ResourceResponse])
def list_resources(db: Session = Depends(get_db_dep)):
    items = ResourceCURD.list_all(db)
    return [
        ResourceResponse(
            id=r.id,
            resource_type=_resource_type_value(r),
            platform=getattr(r, "platform", None),
            title=r.title,
            summary=getattr(r, "summary", None),
            source_url=getattr(r, "source_url", None),
            thumbnail=getattr(r, "thumbnail", None),
            category_id=getattr(r, "category_id", None),
            category_name=getattr(r, "category_name", None),
            difficulty=getattr(r, "difficulty", None),
            tags=getattr(r, "tags", None),
            raw_meta=getattr(r, "raw_meta", None),
            created_at=getattr(r, "created_at", None),
        )
        for r in items
    ]


@router.get("/{resource_id}", response_model=ResourceDetailResponse)
def get_resource_detail(resource_id: int, db: Session = Depends(get_db_dep)):
    obj = db.query(Resource).filter(Resource.id == resource_id).first()
    if not obj:
        raise HTTPException(status_code=404, detail="resource not found")

    return ResourceDetailResponse(
        id=obj.id,
        resource_type=_resource_type_value(obj),
        platform=getattr(obj, "platform", None),
        title=obj.title,
        summary=getattr(obj, "summary", None),
        source_url=getattr(obj, "source_url", None),
        thumbnail=getattr(obj, "thumbnail", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(obj, "category_name", None),
        difficulty=getattr(obj, "difficulty", None),
        tags=getattr(obj, "tags", None),
        raw_meta=getattr(obj, "raw_meta", None),
        created_at=getattr(obj, "created_at", None),
        video=VideoInfo.model_validate(obj.video) if getattr(obj, "video", None) else None,
        doc=DocInfo.model_validate(obj.doc) if getattr(obj, "doc", None) else None,
        article=ArticleInfo.model_validate(obj.article) if getattr(obj, "article", None) else None,
    )


@router.post("/me", response_model=ResourceResponse, status_code=status.HTTP_201_CREATED)
def create_my_resource(payload: ResourceCreateFromUrl, db: Session = Depends(get_db_dep), current_user=Depends(get_current_user)):
    try:
        obj = ResourceCURD.create_from_url(
            db,
            user_id=current_user.id,
            url=str(payload.url),
            category_id=payload.category_id,
            is_system_public=payload.is_public,
        )
        db.commit()
        db.refresh(obj)
    except ValueError as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"创建失败: {e}")

    return ResourceResponse(
        id=obj.id,
        resource_type=_resource_type_value(obj),
        platform=getattr(obj, "platform", None),
        title=obj.title,
        summary=getattr(obj, "summary", None),
        source_url=getattr(obj, "source_url", None),
        thumbnail=getattr(obj, "thumbnail", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(obj, "category_name", None),
        difficulty=getattr(obj, "difficulty", None),
        tags=getattr(obj, "tags", None),
        raw_meta=getattr(obj, "raw_meta", None),
        created_at=getattr(obj, "created_at", None),
    )


@router.post("/me/{resource_id}", response_model=ResourceResponse)
def add_public_resource_to_my_resources(
    resource_id: int,
    db: Session = Depends(get_db_dep),
    current_user=Depends(get_current_user),
):
    obj = db.query(Resource).filter(Resource.id == resource_id).first()
    if not obj:
        raise HTTPException(status_code=404, detail="resource not found")

    try:
        ResourceCURD.attach_to_user(db, user_id=current_user.id, resource_id=obj.id)
        db.commit()
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"添加失败: {e}")

    return ResourceResponse(
        id=obj.id,
        resource_type=_resource_type_value(obj),
        platform=getattr(obj, "platform", None),
        title=obj.title,
        summary=getattr(obj, "summary", None),
        source_url=getattr(obj, "source_url", None),
        thumbnail=getattr(obj, "thumbnail", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(obj, "category_name", None),
        difficulty=getattr(obj, "difficulty", None),
        tags=getattr(obj, "tags", None),
        raw_meta=getattr(obj, "raw_meta", None),
        created_at=getattr(obj, "created_at", None),
    )


@router.post("/me/{resource_id}/attach", response_model=ResourceAttachResponse)
def add_public_resource_to_my_resources_with_status(
    resource_id: int,
    db: Session = Depends(get_db_dep),
    current_user=Depends(get_current_user),
):
    obj = db.query(Resource).filter(Resource.id == resource_id).first()
    if not obj:
        raise HTTPException(status_code=404, detail="resource not found")

    already_exists = (
        db.query(UserResource)
        .filter(UserResource.user_id == current_user.id, UserResource.resource_id == obj.id)
        .first()
        is not None
    )

    try:
        ResourceCURD.attach_to_user(db, user_id=current_user.id, resource_id=obj.id)
        db.commit()
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"添加失败: {e}")

    return ResourceAttachResponse(
        already_exists=already_exists,
        resource=ResourceResponse(
            id=obj.id,
            resource_type=_resource_type_value(obj),
            platform=getattr(obj, "platform", None),
            title=obj.title,
            summary=getattr(obj, "summary", None),
            source_url=getattr(obj, "source_url", None),
            thumbnail=getattr(obj, "thumbnail", None),
            category_id=getattr(obj, "category_id", None),
            category_name=getattr(obj, "category_name", None),
            difficulty=getattr(obj, "difficulty", None),
            tags=getattr(obj, "tags", None),
            raw_meta=getattr(obj, "raw_meta", None),
            created_at=getattr(obj, "created_at", None),
        ),
    )


@router.delete("/me/{resource_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_my_resource(resource_id: int, db: Session = Depends(get_db_dep), current_user=Depends(get_current_user)):
    try:
        ResourceCURD.detach_from_user(db, user_id=current_user.id, resource_id=resource_id)
        db.commit()
    except ValueError as e:
        db.rollback()
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"删除失败: {e}")

    return None


@router.patch("/me/{resource_id}", response_model=ResourceResponse)
def update_my_resource(
    resource_id: int,
    payload: ResourceUpdateRequest,
    db: Session = Depends(get_db_dep),
    current_user=Depends(get_current_user),
):
    try:
        obj = ResourceCURD.update_for_user(
            db,
            user_id=current_user.id,
            resource_id=resource_id,
            title=payload.title,
            summary=payload.summary,
            platform=payload.platform,
            thumbnail=payload.thumbnail,
            category_id=getattr(payload, "category_id", None),
            difficulty=payload.difficulty,
            tags=payload.tags,
            raw_meta=payload.raw_meta,
        )
        db.commit()
        db.refresh(obj)
    except ValueError as e:
        db.rollback()
        msg = str(e)
        if "not found" in msg:
            raise HTTPException(status_code=404, detail=msg)
        raise HTTPException(status_code=400, detail=msg)
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"更新失败: {e}")

    return ResourceResponse(
        id=obj.id,
        resource_type=_resource_type_value(obj),
        platform=getattr(obj, "platform", None),
        title=obj.title,
        summary=getattr(obj, "summary", None),
        source_url=getattr(obj, "source_url", None),
        thumbnail=getattr(obj, "thumbnail", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(obj, "category_name", None),
        difficulty=getattr(obj, "difficulty", None),
        tags=getattr(obj, "tags", None),
        raw_meta=getattr(obj, "raw_meta", None),
        created_at=getattr(obj, "created_at", None),
    )

