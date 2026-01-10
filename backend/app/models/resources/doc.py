from sqlalchemy import Column, Integer, String,DateTime,Boolean,Text
# from sqlalchemy.orm import relationship
from app.db.database import Base

class Doc(Base):
    __tablename__ = "docs"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, index=True, nullable=False)
    description = Column(Text, nullable=True)
    #relationships

    #learning_paths
    #permissions


    def __repr__(self):
        return f"<Doc(id={self.id}, name={self.name})>"
    



