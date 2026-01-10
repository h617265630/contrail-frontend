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
)
from app.curd.learning_path_curd import LearningPathCURD
from app.curd.path_item_curd import PathItemCURD
from app.models.user_learning_path import UserLearningPath
from app.models.learning_path import LearningPath
from app.models.path_item import PathItem


router = APIRouter(prefix="/learning-paths", tags=["learning-paths"])


@router.post("/", response_model=LearningPathResponse, status_code=status.HTTP_201_CREATED)
def create_learning_path(
	payload: LearningPathCreate,
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	lp = LearningPathCURD.create_learning_path(
		db=db, user_id=current_user.id, title=payload.title, description=payload.description
	)
	return lp


@router.get("/", response_model=List[LearningPathResponse])
def list_learning_paths(
	skip: int = Query(0, ge=0),
	limit: int = Query(100, ge=1, le=200),
	db: Session = Depends(get_db_dep),
	current_user=Depends(get_current_user),
):
	return LearningPathCURD.get_learning_paths_by_user(db, current_user.id, skip=skip, limit=limit)


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
		items.append(
			PathItemInLearningPathResponse(
				id=it.id,
				learning_path_id=it.learning_path_id,
				resource_id=it.resource_id,
				resource_type=it.resource_type,  # 与 ResourceKind 的值兼容
				title=it.title,
				position=it.position,
				description=it.description,
				resource_data=None,  # 如需嵌入详情，可在此处根据类型查询并填充
			)
		)

	return LearningPathDetailResponse(
		id=lp.id,
		title=lp.title,
		description=lp.description,
		is_public=lp.is_public,
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



