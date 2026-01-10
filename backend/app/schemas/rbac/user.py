from typing import Optional
from pydantic import BaseModel,EmailStr
from datetime import datetime

class UserBase(BaseModel):
    username: str
    email: EmailStr
    display_name: Optional[str] = None
    avatar_url: Optional[str] = None
    bio: Optional[str] = None
    is_active: Optional[bool] = True
    
    model_config={
        "from_attributes": True
    }

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    display_name: Optional[str] = None
    avatar_url: Optional[str] = None
    bio: Optional[str] = None
    is_active: Optional[bool] = None
 

# 返还给 前端的用户信息,一般只返回简单信息
class UserResponse(UserBase):
    id:int
    created_at: datetime
    updated_at:datetime
    is_superuser:bool
    


class UserOutWithFollowers(UserResponse):
    followers_count: int = 0
    following_count: int = 0
    

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
