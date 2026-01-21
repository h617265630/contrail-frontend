from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user, get_db_dep
from app.curd.resources.resource_curd import ResourceCURD
from app.models.resource import Resource
from app.models.user_resource import UserResource
from app.schemas.resources.extract import ChapterItem, UrlExtractRequest, UrlExtractResponse
from app.schemas.resources.resource import ResourceAttachResponse, ResourceCreateFromUrl, ResourceDetailResponse, ResourceResponse, ResourceUpdateRequest

router = APIRouter(prefix="/resources", tags=["Resources"])


def _raw_resource_kind(obj: Resource) -> str:
    rt = getattr(obj, "resource_type", None)
    val = rt.value if hasattr(rt, "value") else (str(rt) if rt is not None else "")
    return (val or "").strip().lower() or "unknown"


def _present_resource_type(obj: Resource) -> str:
    rt = getattr(obj, "resource_type", None)
    val = rt.value if hasattr(rt, "value") else (str(rt) if rt is not None else "")
    val = (val or "").strip().lower()

    if val == "link":
        url = (getattr(obj, "url", None) or "").strip()
        lower = url.lower()
        host = ""
        try:
            from urllib.parse import urlparse

            host = (urlparse(url).hostname or "").lower()
        except Exception:
            host = ""

        if host.endswith("youtube.com") or host.endswith("youtu.be"):
            return "video"
        if lower.split("?", 1)[0].endswith(".pdf"):
            return "document"
        return "article"

    return val or "unknown"


@router.get("/resolve")
def resolve_public_resource_id_by_url(url: str, db: Session = Depends(get_db_dep)):
    """Resolve a public resource by its URL.

    This is primarily for front-end compatibility when an old UI deep-links with
    a non-numeric local id (e.g. u_...). The caller can provide the original URL
    and get back the canonical DB id.
    """
    raw = (url or "").strip()
    if not raw:
        raise HTTPException(status_code=400, detail="url is required")

    obj = db.query(Resource).filter(Resource.url == raw).first()
    if not obj or not bool(getattr(obj, "is_public", True)):
        raise HTTPException(status_code=404, detail="resource not found")

    return {"id": obj.id}


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
        resource_type=_present_resource_type(obj),
        resource_kind=_raw_resource_kind(obj),
        is_public=bool(getattr(obj, "is_public", True)),
        url=url,
        source=getattr(obj, "source", None),
        category=getattr(obj, "category", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(getattr(obj, "category_ref", None), "name", None),
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
            resource_type=_present_resource_type(r),
            resource_kind=_raw_resource_kind(r),
            is_public=bool(getattr(r, "is_public", True)),
            url=getattr(r, "url", None),
            source=getattr(r, "source", None),
            category=getattr(r, "category", None),
            category_id=getattr(r, "category_id", None),
            category_name=getattr(getattr(r, "category_ref", None), "name", None),
            thumbnail_url=getattr(r, "thumbnail_url", None),
            created_at=getattr(r, "created_at", None),
        )
        for r in items
    ]


@router.get("", response_model=list[ResourceResponse])
def list_resources(db: Session = Depends(get_db_dep)):
    items = ResourceCURD.list_public(db)
    return [
        ResourceResponse(
            id=r.id,
            title=r.title,
            description=getattr(r, "description", None),
            resource_type=_present_resource_type(r),
            resource_kind=_raw_resource_kind(r),
            is_public=bool(getattr(r, "is_public", True)),
            url=getattr(r, "url", None),
            source=getattr(r, "source", None),
            category=getattr(r, "category", None),
            category_id=getattr(r, "category_id", None),
            category_name=getattr(getattr(r, "category_ref", None), "name", None),
            thumbnail_url=getattr(r, "thumbnail_url", None),
            created_at=getattr(r, "created_at", None),
        )
        for r in items
    ]


@router.get("/{resource_id}", response_model=ResourceDetailResponse)
def get_resource_detail(resource_id: int, db: Session = Depends(get_db_dep)):
    obj = db.query(Resource).filter(Resource.id == resource_id).first()
    if not obj:
        raise HTTPException(status_code=404, detail="resource not found")

    if not bool(getattr(obj, "is_public", True)):
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
        resource_type=_present_resource_type(obj),
        resource_kind=_raw_resource_kind(obj),
        is_public=bool(getattr(obj, "is_public", True)),
        url=url,
        source=getattr(obj, "source", None),
        category=getattr(obj, "category", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(getattr(obj, "category_ref", None), "name", None),
        thumbnail_url=getattr(obj, "thumbnail_url", None),
        created_at=getattr(obj, "created_at", None),
        author=meta.get("author"),
        publish_date=meta.get("publish_date"),
        video_id=meta.get("video_id"),
        chapters=[ChapterItem(**c) for c in (meta.get("chapters") or [])],
    )


@router.post("/me", response_model=ResourceResponse, status_code=status.HTTP_201_CREATED)
def create_my_resource(payload: ResourceCreateFromUrl, db: Session = Depends(get_db_dep), current_user=Depends(get_current_user)):
    try:
        obj = ResourceCURD.create_from_url(
            db,
            user_id=current_user.id,
            url=str(payload.url),
            category=payload.category,
            category_id=payload.category_id,
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
        title=obj.title,
        description=getattr(obj, "description", None),
        resource_type=_present_resource_type(obj),
        resource_kind=_raw_resource_kind(obj),
        is_public=bool(getattr(obj, "is_public", True)),
        url=getattr(obj, "url", None),
        source=getattr(obj, "source", None),
        category=getattr(obj, "category", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(getattr(obj, "category_ref", None), "name", None),
        thumbnail_url=getattr(obj, "thumbnail_url", None),
        created_at=getattr(obj, "created_at", None),
    )


@router.post("/me/{resource_id}", response_model=ResourceResponse)
def add_public_resource_to_my_resources(
    resource_id: int,
    db: Session = Depends(get_db_dep),
    current_user=Depends(get_current_user),
):
    obj = db.query(Resource).filter(Resource.id == resource_id).first()
    if not obj or not bool(getattr(obj, "is_public", True)):
        raise HTTPException(status_code=404, detail="resource not found")

    try:
        ResourceCURD.attach_to_user(db, user_id=current_user.id, resource_id=obj.id)
        db.commit()
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"添加失败: {e}")

    return ResourceResponse(
        id=obj.id,
        title=obj.title,
        description=getattr(obj, "description", None),
        resource_type=_present_resource_type(obj),
        resource_kind=_raw_resource_kind(obj),
        is_public=bool(getattr(obj, "is_public", True)),
        url=getattr(obj, "url", None),
        source=getattr(obj, "source", None),
        category=getattr(obj, "category", None),
        thumbnail_url=getattr(obj, "thumbnail_url", None),
        created_at=getattr(obj, "created_at", None),
    )


@router.post("/me/{resource_id}/attach", response_model=ResourceAttachResponse)
def add_public_resource_to_my_resources_with_status(
    resource_id: int,
    db: Session = Depends(get_db_dep),
    current_user=Depends(get_current_user),
):
    obj = db.query(Resource).filter(Resource.id == resource_id).first()
    if not obj or not bool(getattr(obj, "is_public", True)):
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
            title=obj.title,
            description=getattr(obj, "description", None),
            resource_type=_present_resource_type(obj),
            resource_kind=_raw_resource_kind(obj),
            is_public=bool(getattr(obj, "is_public", True)),
            url=getattr(obj, "url", None),
            source=getattr(obj, "source", None),
            category=getattr(obj, "category", None),
            thumbnail_url=getattr(obj, "thumbnail_url", None),
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
            url=str(payload.url) if payload.url else None,
            title=payload.title,
            description=payload.description,
            is_public=payload.is_public,
            category_id=payload.category_id,
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
        title=obj.title,
        description=getattr(obj, "description", None),
        resource_type=_present_resource_type(obj),
        resource_kind=_raw_resource_kind(obj),
        is_public=bool(getattr(obj, "is_public", True)),
        url=getattr(obj, "url", None),
        source=getattr(obj, "source", None),
        category=getattr(obj, "category", None),
        category_id=getattr(obj, "category_id", None),
        category_name=getattr(getattr(obj, "category_ref", None), "name", None),
        thumbnail_url=getattr(obj, "thumbnail_url", None),
        created_at=getattr(obj, "created_at", None),
    )

