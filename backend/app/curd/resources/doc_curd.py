from sqlalchemy.orm import Session
from typing import List, Optional

from app.models.resources.doc import Doc
from app.schemas.resources.doc import DocCreate


class DocCURD:
    @staticmethod
    def get_doc(db: Session, product_id: int) -> Optional[Doc]:
        return db.query(Doc).filter(Doc.id == product_id).first()
    
    
    @staticmethod
    def create_doc(db: Session, doc_in: DocCreate) -> Doc:
        data = doc_in.model_dump(exclude_unset=True)
        doc = Doc(**data)
        db.add(doc)
        db.commit()
        db.refresh(doc)
        
        return doc
    
    @staticmethod
    def list_docs(db: Session, skip: int = 0, limit: int = 100) -> List[Doc]:
        docs = db.query(Doc).offset(skip).limit(limit).all()
        return docs
    
    @staticmethod
    def delete_doc(db: Session, doc: Doc) -> None:
        db.delete(doc)
        db.commit() 