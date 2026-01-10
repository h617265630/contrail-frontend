from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.openapi.docs import get_swagger_ui_html
from app.routers import learning_path
from app.routers.rbac import role,user,permission




from app.db.database import engine, Base
# Ensure rbac model modules (including association classes) are imported so
# SQLAlchemy can resolve relationships that reference mapped classes/tables.
import app.models.rbac.associations
import app.models.rbac.user
import app.models.rbac.role
import app.models.rbac.permission
# 确保关联/中间表与关系类被加载，避免字符串解析失败
from fastapi.middleware.cors import CORSMiddleware
from app.db.database import SessionLocal
from app.core.initial_data import init_default_data
from app.routers.resources import clip, doc, product, video
Base.metadata.create_all(bind=engine)

"""
Custom FastAPI app with local Swagger UI assets to avoid CDN timeouts.
"""
app = FastAPI(title="User Management API", debug=True, docs_url=None, redoc_url=None)

# 配置 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 允许所有源，开发环境可以这样设置
    allow_credentials=True,
    allow_methods=["*"],  # 允许所有方法
    allow_headers=["*"],  # 允许所有头
)

# Serve local static files (e.g., Swagger UI assets) from backend/static
app.mount("/static", StaticFiles(directory="static"), name="static")

# Custom /docs using local swagger-ui assets
@app.get("/docs", include_in_schema=False)
def custom_swagger_ui():
    return get_swagger_ui_html(
        openapi_url=app.openapi_url,
        title="API Docs",
        swagger_js_url="/static/swagger/swagger-ui-bundle.js",
        swagger_css_url="/static/swagger/swagger-ui.css",
    )
app.include_router(user.router)
app.include_router(video.router)
app.include_router(clip.router)
app.include_router(learning_path.router)
app.include_router(product.router)
app.include_router(doc.router)
app.include_router(role.router)
app.include_router(permission.router)   

@app.on_event("startup")
async def startup_event():
    """应用启动时初始化数据"""
    # 防止同一进程内重复初始化（如被多次触发）
    if getattr(app.state, "initialized", False):
        return
    app.state.initialized = True

    # 使用上下文管理自动关闭会话
    with SessionLocal() as db:
        init_default_data(db)