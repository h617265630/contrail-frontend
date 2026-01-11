from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user, get_db_dep
from app.curd.resources.resource_curd import ResourceCURD
from app.schemas.resources.extract import ChapterItem, UrlExtractRequest, UrlExtractResponse
from app.schemas.resources.resource import ResourceCreateFromUrl, ResourceDetailResponse, ResourceResponse

router = APIRouter(prefix="/resources", tags=["Resources"])


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
        chapters=[ChapterItem(**c) for c in (meta.get("chapters") or [])],
    )


@router.get("/me/{resource_id}", response_model=ResourceDetailResponse)
def get_my_resource_detail(resource_id: int, db: Session = Depends(get_db_dep), current_user=Depends(get_current_user)):
    # Ensure the resource belongs to current user
    items = ResourceCURD.list_for_user(db, user_id=current_user.id)
    obj = next((r for r in items if r.id == resource_id), None)
    if not obj:
        raise HTTPException(status_code=404, detail="resource not found")

    url = getattr(obj, "url", None)
    meta = {}
    if url:
        try:
            meta = ResourceCURD.extract_from_url(str(url))
        except Exception:
            meta = {}

    return ResourceDetailResponse(
        id=obj.id,
        title=obj.title,
        description=getattr(obj, "description", None),
        resource_type=getattr(obj, "resource_type", None).value if getattr(obj, "resource_type", None) else "unknown",
        url=url,
        source=getattr(obj, "source", None),
        category=getattr(obj, "category", None),
        thumbnail_url=getattr(obj, "thumbnail_url", None),
        created_at=getattr(obj, "created_at", None),
        author=meta.get("author"),
        publish_date=meta.get("publish_date"),
        video_id=meta.get("video_id"),
        chapters=[ChapterItem(**c) for c in (meta.get("chapters") or [])],
    )


@router.get("/me", response_model=list[ResourceResponse])
def list_my_resources(db: Session = Depends(get_db_dep), current_user=Depends(get_current_user)):
    items = ResourceCURD.list_for_user(db, user_id=current_user.id)
    return [
        ResourceResponse(
            id=r.id,
            title=r.title,
            description=getattr(r, "description", None),
            resource_type=getattr(r, "resource_type", None).value if getattr(r, "resource_type", None) else "unknown",
            url=getattr(r, "url", None),
            source=getattr(r, "source", None),
            category=getattr(r, "category", None),
            thumbnail_url=getattr(r, "thumbnail_url", None),
            created_at=getattr(r, "created_at", None),
        )
        for r in items
    ]


@router.post("/me", response_model=ResourceResponse, status_code=status.HTTP_201_CREATED)
def create_my_resource(payload: ResourceCreateFromUrl, db: Session = Depends(get_db_dep), current_user=Depends(get_current_user)):
    try:
        obj = ResourceCURD.create_from_url(db, user_id=current_user.id, url=str(payload.url), category=payload.category)
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
        title=obj.title,
        description=getattr(obj, "description", None),
        resource_type=getattr(obj, "resource_type", None).value if getattr(obj, "resource_type", None) else "unknown",
        url=getattr(obj, "url", None),
        source=getattr(obj, "source", None),
        category=getattr(obj, "category", None),
        thumbnail_url=getattr(obj, "thumbnail_url", None),
        created_at=getattr(obj, "created_at", None),
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
