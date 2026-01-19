from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.deps import get_db_dep
from app.models.category import Category
from app.schemas.category import CategoryResponse


router = APIRouter(prefix="/categories", tags=["categories"])


@router.get("/", response_model=List[CategoryResponse])
def list_categories(db: Session = Depends(get_db_dep)):
    return db.query(Category).order_by(Category.id.asc()).all()
