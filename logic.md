# 项目功能逻辑（logic.md）

> 更新时间：2026-02-10

本文件用于梳理当前仓库中“实际已接入/可用”的业务模块、接口边界、权限模型（登录、RBAC、超级管理员）以及各端（Backend / Web / Flutter）的功能支持范围。

---

## 1. 项目整体架构

- **后端**：FastAPI + SQLAlchemy + PostgreSQL
  - 入口：`backend/app/main.py`
  - 鉴权：JWT Bearer Token（`Authorization: Bearer <token>`）
  - RBAC：角色/权限表 + 依赖注入校验（`PermissionChecker([...])`）
- **Web 前端**：Vue3 + Vite + Pinia + Axios
  - 路由：`frontend/app/src/router.ts`
  - 请求封装：`frontend/app/src/utils/request.ts`（`baseURL: http://localhost:8000`）
- **Flutter iOS 客户端**：Flutter + go_router + Dio
  - 路由：`flutterapp/path_ios/lib/router/app_router.dart`
  - API 客户端：`flutterapp/path_ios/lib/core/api_client.dart`

---

## 2. 用户与权限模型

### 2.1 登录态与 Token

- **登录接口**：`POST /users/login`
  - 使用 `OAuth2PasswordRequestForm`（即 `application/x-www-form-urlencoded`）
  - 返回：`{ access_token, token_type }`
- **Token 携带方式**：
  - Web：`request.ts` 在请求拦截器内从 `localStorage(learnsmart_token)` 读 token 并注入 `Authorization`
  - Flutter：`ApiClient` 通过 `tokenProvider()` 注入 `Authorization`

### 2.2 基础用户权限（Active / Superuser）

用户表关键字段（见 `database_structure.md` / `backend/app/models/rbac/user.py`）：

- `is_active`：是否启用（禁用用户不应被允许继续使用）
- `is_superuser`：是否超级管理员（拥有所有权限，RBAC 直接放行）

> 注意：后端 `get_current_active_user` 存在，但当前多数路由只依赖 `get_current_user`，即“是否 active”的强校验需要以路由实际 Depends 为准。

### 2.3 RBAC（Roles / Permissions）

- 表结构：
  - `roles`、`permissions`、`user_roles`、`role_permissions`
- 校验逻辑：`backend/app/core/deps.py::PermissionChecker`
  - 如果 `current_user.is_superuser == true`：直接允许
  - 否则：需要 `current_user.get_all_permissions()` 包含所有必需权限码

### 2.4 默认数据（系统初始化）

应用启动时（`backend/app/main.py` -> `init_default_data(db)`）会初始化：

- **默认权限**（部分示例）：
  - `user.read/user.create/user.update/user.delete`
  - `role.read/role.create/role.update/role.delete`
  - `permission.read/permission.create/permission.update/permission.delete`
  - `video.read/video.upload/video.update/video.delete`
  - `clip.read/clip.create/clip.update/clip.delete`
- **默认角色**：`super_admin/admin/editor/user/guest`
- **默认超级管理员用户**：
  - `username=admin`
  - `password=admin123`
  - `is_superuser=true`
- **默认分类**：AI/Design/UI/Frontend/Backend/Handmade/Other

---

## 3. 后端模块与接口（以 `backend/app/main.py` 实际 include_router 为准）

下面列的是“后端实际挂载并可访问”的路由模块。

### 3.1 Users（用户）`/users`

代码位置：`backend/app/routers/rbac/user.py`

- **公开**：
  - `POST /users/register` 注册
  - `POST /users/login` 登录
- **需要登录**：
  - `GET /users/me` 获取当前用户
  - `PATCH /users/me` 更新用户资料（display_name/avatar_url/bio）
  - `POST /users/me/password` 修改密码
  - `POST /users/me/avatar` 上传头像
- **需要权限**（RBAC）：
  - `GET /users/` 获取用户列表（需要 `user.read`）
  - `PATCH /users/{user_id}/status` 启用/禁用用户（需要 `user.update`）

> 备注：`/users/{user_id}` 读取用户详情目前未加鉴权依赖（实现上是开放的），属于权限边界不严格的点。

### 3.2 Categories（分类）`/categories`

代码位置：`backend/app/routers/category.py`

- **需要登录**：
  - `GET /categories/` 获取分类列表（系统分类 + 自建分类）
  - `POST /categories/` 新建分类（归属当前用户）

分类语义：
- 系统分类：`Category.is_system == true`
- 用户分类：`Category.owner_user_id == current_user.id`

### 3.3 Resources（资源库）`/resources`

代码位置：`backend/app/routers/resources/resource.py`

资源模型：基表 `resources` + 子表（video/doc/article） + 用户关联表 `user_resource`。

- **公开（无需登录）**：
  - `GET /resources` 公共资源列表（当前实现为全量 `ResourceCURD.list_all`，不强制过滤 is_public）
  - `GET /resources/{resource_id}` 公共资源详情
  - `POST /resources/extract` 解析 URL 元数据（标题/缩略图/章节等）
- **需要登录（我的资源）**：
  - `GET /resources/me` 我的资源列表（通过 `user_resource`）
  - `GET /resources/me/{resource_id}` 我的资源详情（会记录打开次数等行为字段）
  - `POST /resources/me` 从 URL 创建我的资源
  - `POST /resources/me/{resource_id}` 将公共资源加入“我的资源”
  - `POST /resources/me/{resource_id}/attach` 同上但带 `already_exists` 状态
  - `PATCH /resources/me/{resource_id}` 更新我的资源（标题/summary/platform/thumbnail/category/tags/weight 等）
  - `DELETE /resources/me/{resource_id}` 从“我的资源”移除
- **仅超级管理员**：
  - `DELETE /resources/{resource_id}` 删除资源（同时级联删除 video/doc/article/user_resource/path_item）

从 URL 创建资源的关键规则（`ResourceCURD.create_from_url`）：
- `category_id` **必填**（否则 400）
- 解析 URL 得到 `platform/title/description/thumbnail/chapters/...`
- 推断 `resource_type`：`video/document/article`（代码里用字符串值）
- 创建资源后自动写入 `user_resource` 关联（并可设置 `is_public/manual_weight`）

### 3.4 Learning Paths（学习路径）`/learning-paths`

代码位置：`backend/app/routers/learning_path.py`

学习路径表：`learning_paths` + `path_items` + `user_learning_paths`。

- **公开（无需登录）**：
  - `GET /learning-paths/public` 公共路径列表
  - `GET /learning-paths/public/{learning_path_id}` 公共路径详情（包含 path_items + resource_data）
- **需要登录（我的路径）**：
  - `GET /learning-paths` 获取“我的路径”（以 `user_learning_paths` 为准）
  - `POST /learning-paths` 创建路径（创建者自动拥有）
  - `GET /learning-paths/{id}` 路径详情（会校验 user 是否拥有该路径）
  - `PATCH /learning-paths/{id}` 更新路径（校验拥有关系）
  - `DELETE /learning-paths/{id}` 删除路径（校验拥有关系）
  - `POST /learning-paths/{id}/items` 往路径添加资源（校验拥有关系）
  - `GET /learning-paths/{id}/items` 列出路径条目
  - `DELETE /learning-paths/{id}/items/{resource_id}` 从路径移除资源
  - `POST /learning-paths/me/{learning_path_id}/attach` 将公共路径加入“我的路径”（写入 `user_learning_paths`）

权限规则核心：
- “是否拥有学习路径”是通过 `user_learning_paths` 判断，不靠 `learning_paths.owner_id`（该字段也不存在）。

### 3.5 Progress（进度）`/progress`

代码位置：`backend/app/routers/progress.py`

进度表：`progress`（以 `path_item_id` 粒度记录）。

- **需要登录**：
  - `GET /progress/me?learning_path_id=...` 返回该路径所有 item 的进度（不存在则默认 0）
  - `GET /progress/me/item/{path_item_id}` 获取单个 item 的进度
  - `PUT /progress/me` upsert 更新进度

权限规则：
- 任何 progress 读写前都会校验用户是否拥有对应 learning_path（通过 `user_learning_paths`）。

### 3.6 Reader（网页正文抽取）`/reader`

代码位置：`backend/app/routers/reader.py`

- **公开（无需登录）**：
  - `POST /reader/extract` 传入 URL，后端抓取 HTML 并用 readability 提取正文

安全策略（实现中包含）：
- 仅允许 `http/https`
- 阻止 `localhost`、阻止解析到私网 IP（防 SSRF）
- HTML 清洗（bleach）
- 缓存（24h TTL）

### 3.7 User Images（用户图片）`/user-images`

代码位置：`backend/app/routers/user_image.py`

- **需要登录**：
  - `GET /user-images/me`
  - `POST /user-images/me/upload` 上传图片并落盘到 `backend/static/user_images/`，返回可访问 URL

### 3.8 User Files（用户文件）`/user-files`

代码位置：`backend/app/routers/user_file.py`

- **需要登录**：
  - `GET /user-files/me`
  - `POST /user-files/me/upload` 仅支持 `.md/.txt`，落盘到 `backend/static/user_files/`，并在数据库保存文本内容

### 3.9 RBAC 管理接口（角色/权限/分配）

代码位置：`backend/app/routers/rbac/*`

- `/role/*`：角色管理（部分接口使用 `PermissionChecker`，部分仅要求登录）
- `/permission/*`：权限管理（部分接口使用 `PermissionChecker`，部分仅要求登录）
- `/user-role/*`：为用户分配角色（严格使用 `PermissionChecker`）
- `/role-permission/*`：查询当前用户权限（只要求登录）

> 备注：存在“文档注释写需要权限，但实现只依赖 get_current_user”的情况（例如部分 list 接口）。这属于权限边界尚未完全收敛。

---

## 4. 代码存在但当前后端未挂载的模块（功能范围提示）

以下路由文件在仓库中存在，但 **`backend/app/main.py` 未 include_router**，因此默认情况下不会对外提供服务：

- `backend/app/routers/video.py`（/videos）
- `backend/app/routers/doc.py`（/documents）
- `backend/app/routers/resources/video.py`（/videos 的另一套实现）
- `backend/app/routers/resources/clip.py`（/clips）
- `backend/app/routers/resources/doc.py`（/documents）

此外，`api清单.txt` 里提到的：
- `/auth/*`（register/login/refresh/logout）
- `/crawler/*`
- `/admin/*`
- `/videos/source/*`、`/clips/*` 等

在当前后端挂载路由中**不完整/不一致**，属于“规划/历史清单”，不等于当前可用能力。

---

## 5. Web 前端（Vue）功能支持范围

### 5.1 路由与页面

路由表：`frontend/app/src/router.ts`

主要页面：
- 公共：Home、Resources、ResourceDetail(三种类型)、About 系列
- 账号：Login/Register、Account（含子页面）
- 学习路径：MyLearningPath、CreatePath、LearningPathDetail/Linear/Edit、LearningPool
- 资源：ResourceLibrary、MyResource、AddResource、MyResourceEdit、AddResourceToPath
- 其他：Notification、Creator、Deck、Plan、Tools、Stack、Partical 系列

### 5.2 鉴权状态

- token/user 存在 `localStorage`（`learnsmart_token` / `learnsmart_user`）
- Axios 拦截器在 401 时会清理 token 并硬跳转 `/login`

> 注意：Vue Router 代码中未看到统一的“路由守卫”去阻止未登录访问某些页面；多数页面应依赖接口 401 后跳转。

---

## 6. Flutter iOS 客户端功能支持范围

### 6.1 路由与页面

路由表：`flutterapp/path_ios/lib/router/app_router.dart`

- 公开（未登录可访问）：
  - `/login`、`/register`
  - `/resources`（公共资源库）
  - `/resources/{type}/{id}`（公共资源详情）
  - `/home`（目前在 Shell 内，但路由重定向会控制）
- 需要登录（由 `requiresAuth` 前缀表控制）：
  - `/my-resources`（我的资源列表）
  - `/my-resources/add`（新增资源）
  - `/my-paths`（我的路径 / 公共路径入口）
  - `/createpath`（创建路径）
  - `/learningpath/...`（路径详情）
  - `/account/...`（账户中心）
  - `/notification`（Message / Share Inbox 页面）

### 6.2 API 支持

Flutter 端 `AppServices` 已封装：
- AuthApi / UserApi / CategoryApi / ResourceApi / LearningPathApi / ProgressApi / ReaderApi / UserFileApi / UserImageApi

### 6.3 重要限制（当前实现状态）

- Flutter 的 Message 页目前是 **Share Inbox**（手动粘贴 URL -> 导入资源）。
- “真正 iOS Share Extension（系统分享面板选中本 App）”目前还未接入到工程（属于待办）。

---

## 7. 静态资源与文件存储

后端通过 `app.mount('/static', ...)` 暴露 `backend/static/`。

- 用户头像：`/static/avatars/...`
- 用户图片：`/static/user_images/...`
- 用户文件：`/static/user_files/...`
- Swagger UI 静态资源：`/static/swagger/...`

> 当前 URL 中大量硬编码 `http://localhost:8000/...`，适用于本地开发；生产环境需要改为可配置域名。

---

## 8. 功能支持范围总览（面向产品/交付）

- **已稳定可用（核心链路）**：
  - 注册/登录/JWT
  - 我的资源：从 URL 导入、列表、详情、编辑、删除
  - 公共资源库：列表、详情
  - 学习路径：创建、我的路径列表、公共路径列表/详情、添加资源、移除资源
  - 进度：按 path_item 记录与查询
  - 分类：系统分类 + 用户自定义分类
  - Reader：URL 正文提取
  - 用户文件/图片上传（md/txt + image）
- **代码存在但未接入/未对外开放**：
  - /videos、/clips、/documents 等视频/剪辑/文档的独立模块路由（未 include_router）
  - crawler/admin/auth-refresh 等清单项（当前后端未实现或未挂载）
- **权限与管理能力**：
  - 具备 RBAC 数据模型与部分接口
  - 超级管理员可删除任意资源
  - 部分“列表接口的权限校验”目前不一致，需要后续统一（是否全部走 PermissionChecker）

---

## 9. 后续建议（可选）

- 将 `baseURL`、静态资源域名等改成环境变量配置（Web/Flutter/Backend 三端一致）
- 统一权限策略：
  - 列表/详情接口是否需要权限码、仅登录、或公开
  - 对 `/users/{id}` 等接口增加权限校验
- 若要实现“从 YouTube 分享到 App”：
  - iOS 需要 Share Extension + App Group；Flutter 端需要接收分享并跳转到 `/notification?url=...`
