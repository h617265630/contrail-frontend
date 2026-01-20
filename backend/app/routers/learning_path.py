from typing import List

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.core.deps import get_db_dep, get_current_user
from app.schemas.learning_path import (
	LearningPathCreate,
	LearningPathUpdate,
	LearningPathResponse,
	LearningPathDetailResponse,
	PathItemInLearningPathResponse,
	AddResourceToLearningPathRequest,
	ResourceKind,
	LearningPathAttachResponse,
)
from app.curd.learning_path_curd import LearningPathCURD
from app.curd.path_item_curd import PathItemCURD
from app.models.user_learning_path import UserLearningPath
from app.models.learning_path import LearningPath
from app.models.path_item import PathItem
from app.models.resource import Resource
from app.schemas.resources.resource import ResourceResponse


router = APIRouter(prefix="/learning-paths", tags=["learning-paths"])


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


def _to_resource_response(obj: Resource) -> ResourceResponse:
	return ResourceResponse(
		id=obj.id,
		title=obj.title,
		description=getattr(obj, "description", None),
		resource_type=_present_resource_type(obj),
		is_public=bool(getattr(obj, "is_public", True)),
		url=getattr(obj, "url", None),
		source=getattr(obj, "source", None),
		category=getattr(obj, "category", None),
		category_id=getattr(obj, "category_id", None),
		category_name=getattr(getattr(obj, "category_ref", None), "name", None),
		thumbnail_url=getattr(obj, "thumbnail_url", None),
		created_at=getattr(obj, "created_at", None),
	)


@router.post("/", response_model=LearningPathResponse, status_code=status.HTTP_201_CREATED)
def create_learning_path(
	payload: LearningPathCreate,
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	try:
		lp = LearningPathCURD.create_learning_path(
			db=db,
			user_id=current_user.id,
			title=payload.title,
			description=payload.description,
			is_public=payload.is_public,
			cover_image_url=getattr(payload, "cover_image_url", None),
			category_id=payload.category_id,
		)
	except ValueError as e:
		raise HTTPException(status_code=400, detail=str(e))
	return lp


@router.get("/public", response_model=List[LearningPathResponse])
def list_public_learning_paths(
	skip: int = Query(0, ge=0),
	limit: int = Query(100, ge=1, le=200),
	db: Session = Depends(get_db_dep),
):
	return LearningPathCURD.list_public_learning_paths(db, skip=skip, limit=limit)


@router.get("/public/{learning_path_id}", response_model=LearningPathDetailResponse)
def get_public_learning_path_detail(
	learning_path_id: int,
	db: Session = Depends(get_db_dep),
):
	lp = LearningPathCURD.get_learning_path_with_items(db, learning_path_id)
	if not lp or (not bool(getattr(lp, "is_public", False))) or (not bool(getattr(lp, "is_active", True))):
		raise HTTPException(status_code=404, detail="LearningPath not found")

	items: List[PathItemInLearningPathResponse] = []
	for it in lp.path_items:
		res = getattr(it, "resource", None)
		resource_data = None
		# Public endpoint: only embed if the referenced resource is public.
		if res is not None and bool(getattr(res, "is_public", False)):
			resource_data = _to_resource_response(res)
		items.append(
			PathItemInLearningPathResponse(
				id=it.id,
				learning_path_id=it.learning_path_id,
				resource_id=it.resource_id,
				resource_type=it.resource_type,
				title=it.title,
				position=it.position,
				description=it.description,
				resource_data=resource_data,
			)
		)

	return LearningPathDetailResponse(
		id=lp.id,
		title=lp.title,
		description=lp.description,
		is_public=lp.is_public,
		cover_image_url=getattr(lp, "cover_image_url", None),
		category_id=getattr(lp, "category_id", None),
		category_name=getattr(lp, "category_name", None),
		is_active=lp.is_active,
		path_items=items,
	)


@router.get("/", response_model=List[LearningPathResponse])
def list_learning_paths(
	skip: int = Query(0, ge=0),
	limit: int = Query(100, ge=1, le=200),
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	return LearningPathCURD.get_learning_paths_by_user(db, current_user.id, skip=skip, limit=limit)


@router.post("/me/{learning_path_id}/attach", response_model=LearningPathAttachResponse)
def attach_public_learning_path_to_me(
	learning_path_id: int,
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	# Only allow attaching public + active learning paths.
	lp = db.query(LearningPath).filter(LearningPath.id == learning_path_id).first()
	if not lp or (not bool(getattr(lp, "is_public", False))) or (not bool(getattr(lp, "is_active", True))):
		raise HTTPException(status_code=404, detail="LearningPath not found")

	already_exists = (
		db.query(UserLearningPath)
		.filter(
			UserLearningPath.user_id == current_user.id,
			UserLearningPath.learning_path_id == learning_path_id,
		)
		.first()
		is not None
	)

	if not already_exists:
		try:
			db.add(UserLearningPath(user_id=current_user.id, learning_path_id=learning_path_id))
			db.commit()
		except Exception as e:
			db.rollback()
			raise HTTPException(status_code=400, detail=f"添加失败: {e}")

	return LearningPathAttachResponse(
		already_exists=already_exists,
		learning_path=LearningPathResponse.model_validate(lp),
	)


def _ensure_ownership(db: Session, user_id: int, learning_path_id: int) -> LearningPath:
	lp = db.query(LearningPath).filter(LearningPath.id == learning_path_id).first()
	if not lp:
		raise HTTPException(status_code=404, detail="LearningPath not found")
	assoc = (
		db.query(UserLearningPath)
		.filter(
			UserLearningPath.user_id == user_id,
			UserLearningPath.learning_path_id == learning_path_id,
		)
		.first()
	)
	if not assoc:
		raise HTTPException(status_code=403, detail="No permission for this learning path")
	return lp


@router.get("/{learning_path_id}", response_model=LearningPathDetailResponse)
def get_learning_path_detail(
	learning_path_id: int,
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	_ensure_ownership(db, current_user.id, learning_path_id)
	lp = LearningPathCURD.get_learning_path_with_items(db, learning_path_id)
	if not lp:
		raise HTTPException(status_code=404, detail="LearningPath not found")

	# 将 ORM 的 path_items 映射为 schema
	items: List[PathItemInLearningPathResponse] = []
	for it in lp.path_items:
		res = getattr(it, "resource", None)
		resource_data = _to_resource_response(res) if res is not None else None
		items.append(
			PathItemInLearningPathResponse(
				id=it.id,
				learning_path_id=it.learning_path_id,
				resource_id=it.resource_id,
				resource_type=it.resource_type,  # 与 ResourceKind 的值兼容
				title=it.title,
				position=it.position,
				description=it.description,
				resource_data=resource_data,
			)
		)

	return LearningPathDetailResponse(
		id=lp.id,
		title=lp.title,
		description=lp.description,
		is_public=lp.is_public,
		cover_image_url=getattr(lp, "cover_image_url", None),
		category_id=getattr(lp, "category_id", None),
		category_name=getattr(lp, "category_name", None),
		is_active=lp.is_active,
		path_items=items,
	)


@router.delete("/{learning_path_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_learning_path(
	learning_path_id: int,
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	lp = _ensure_ownership(db, current_user.id, learning_path_id)
	LearningPathCURD.delete_learning_path(db, lp)
	return None


@router.patch("/{learning_path_id}", response_model=LearningPathResponse)
def update_learning_path(
	learning_path_id: int,
	payload: LearningPathUpdate,
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	lp = _ensure_ownership(db, current_user.id, learning_path_id)

	# Apply partial updates.
	data = payload.model_dump(exclude_unset=True)
	for key, value in data.items():
		setattr(lp, key, value)

	try:
		db.add(lp)
		db.commit()
		db.refresh(lp)
	except Exception as e:
		db.rollback()
		raise HTTPException(status_code=400, detail=f"更新失败: {e}")

	return lp


@router.post("/{learning_path_id}/items", response_model=PathItemInLearningPathResponse, status_code=status.HTTP_201_CREATED)
def add_resource_to_learning_path(
	learning_path_id: int,
	payload: AddResourceToLearningPathRequest,
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	_ensure_ownership(db, current_user.id, learning_path_id)

	item = LearningPathCURD.add_resource_to_learning_path(
		db=db,
		learning_path_id=learning_path_id,
		resource_id=payload.resource_id,
		resource_type=payload.resource_type.value,
		title=payload.title,
		description=payload.description,
		position=payload.position,
	)
	return PathItemInLearningPathResponse(
		id=item.id,
		learning_path_id=item.learning_path_id,
		resource_id=item.resource_id,
		resource_type=item.resource_type,
		title=item.title,
		position=item.position,
		description=item.description,
		resource_data=None,
	)


@router.delete("/{learning_path_id}/items/{resource_id}")
def remove_resource_from_learning_path(
	learning_path_id: int,
	resource_id: int,
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	_ensure_ownership(db, current_user.id, learning_path_id)
	ok = LearningPathCURD.remove_resource_from_learning_path(db, learning_path_id, resource_id)
	if not ok:
		raise HTTPException(status_code=404, detail="Path item not found")
	return {"success": True}


@router.get("/{learning_path_id}/items", response_model=List[PathItemInLearningPathResponse])
def list_path_items(
	learning_path_id: int,
	skip: int = Query(0, ge=0),
	limit: int = Query(100, ge=1, le=200),
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	_ensure_ownership(db, current_user.id, learning_path_id)
	items = PathItemCURD.list_by_learning_path(db, learning_path_id, skip=skip, limit=limit)
	return [
		PathItemInLearningPathResponse(
			id=it.id,
			learning_path_id=it.learning_path_id,
			resource_id=it.resource_id,
			resource_type=it.resource_type,
			title=it.title,
			position=it.position,
			description=it.description,
			resource_data=None,
		)
		for it in items
	]



