# database_structure

> 更新时间：2026-01-19

本文档用于记录当前后端（FastAPI + SQLAlchemy + Alembic）对应的数据库表结构与表关系，便于前后端联调与后续迁移维护。

说明与约定：
- 字段类型以 SQLAlchemy 模型/迁移为准，数据库真实类型可能因方言（Postgres）略有差异。
- 本项目存在“资源多态继承”：`resources` 为基表，不同资源类型在子表中扩展（如 `link_resources`、`videos`、`clips`）。
- `categories` 为通用分类表，`resources.category_id`、`learning_paths.category_id` 均指向它。
---

## 1. 核心业务域（Learning Path + Resource）

### 1.1 `categories`
分类表（支持树形结构）。

- 主键：`id`
- 字段：
  - `id` (PK)
  - `name`（唯一，索引）
  - `code`（唯一，索引）
  - `parent_id`（FK → `categories.id`，自引用，可空）
  - `level`（层级，默认 0）
  - `description`（可空）
  - `is_leaf`（是否叶子节点，默认 true/1）
  - `created_at`
- 关系：
  - 自引用：`categories.parent_id` → `categories.id`
  - 与视频多对多：通过 `video_category`（见 2.3）

### 1.2 `learning_paths`
学习路径主表。

- 主键：`id`
- 字段：
  - `id` (PK)
  - `title`
  - `description`（可空）
  - `is_public`（是否公开）
  - `is_active`（是否可用）
  - `cover_image_url`（可空；学习路径封面 URL，可为 data-url 或普通 URL）
  - `category_id`（FK → `categories.id`，可空，索引）
- 关系：
  - 1 对多：`learning_paths.id` ← `path_items.learning_path_id`
  - 多对多（用户拥有的学习路径）：通过 `user_learning_paths`

### 1.3 `path_items`
学习路径中的条目（某路径中某个资源的编排记录）。

- 主键：`id`
- 字段：
  - `id` (PK)
  - `learning_path_id`（FK → `learning_paths.id`，不可空）
  - `resource_id`（FK → `resources.id`，不可空）
  - `position`（在路径中的顺序，不可空）
  - `description`（可空）
- 约束：
  - `uq_learning_path_position`：(`learning_path_id`, `position`) 唯一
  - `uq_learning_path_resource`：(`learning_path_id`, `resource_id`) 唯一
- 关系：
  - 多对一：`path_items.learning_path_id` → `learning_paths.id`
  - 多对一：`path_items.resource_id` → `resources.id`

### 1.4 `resources`
资源基表（多态继承基类）。

- 主键：`id`
- 字段（模型定义）：
  - `id` (PK)
  - `title`
  - `resource_type`（枚举 `resourcetype`：当前使用值包含 `video` / `clip` / `link`）
  - `description`（可空）
  - `is_active`
  - `is_public`（公开资源库可见性，默认 true）
  - `category_id`（FK → `categories.id`，可空，索引）
  - `created_at`
  - `updated_at`
- 关系：
  - 1 对多：`resources.id` ← `path_items.resource_id`
  - 多对多（用户收藏/关联资源）：通过 `user_resource`
  - 多态子表：`link_resources` / `videos` / `clips`（见 2.1/2.2/2.4）

### 1.5 `user_learning_paths`
用户与学习路径的关联表（“我的路径”来源）。

- 主键：联合主键 (`user_id`, `learning_path_id`)
- 字段：
  - `user_id`（FK → `users.id`）
  - `learning_path_id`（FK → `learning_paths.id`）
- 语义：
  - `/learning-paths/` 这类“我的路径”列表应当以此表为准（用户自己创建的通常也会在创建时插入该关联）。

### 1.6 `user_resource`
用户与资源的关联表（“我的资源”来源）。

- 主键：联合主键 (`user_id`, `resource_id`)
- 字段：
  - `user_id`（FK → `users.id`）
  - `resource_id`（FK → `resources.id`）
  - `created_at`
- 约束：
  - `uq_user_resource`：(`user_id`, `resource_id`) 唯一

---

## 2. 资源子类型（继承/扩展表）

> 这些表通过 `id`（同时也是 FK）与 `resources.id` 一一对应，实现“类表继承（joined table inheritance）”。

### 2.1 `link_resources`
链接资源（通常是 URL 抓取到的公开视频/文章）。

- 主键：`id`（PK，同时 FK → `resources.id`）
- 字段：
  - `id` (PK/FK)
  - `url`（唯一，索引）
  - `source`（可空）
  - `category`（可空；历史遗留字符串分类，仍保留兼容）
  - `thumbnail_url`（可空）
- 备注：
  - 真实分类推荐使用 `resources.category_id` → `categories.id`。

### 2.2 `videos`
视频资源（继承自 `resources`）。

- 主键：`id`（PK，同时 FK → `resources.id`）
- 字段：
  - `id` (PK/FK)
  - `file_size`
  - `file_path`
  - `thumbnail_path`（可空）
  - `duration`
  - `view_count`
- 关系：
  - 多对多（视频-分类）：通过 `video_category`
  - 多对多（用户-视频）：通过 `user_video`（见 3.1）
  - 1 对多（视频-观看记录）：`watch_history.video_id` → `videos.id`
  - 1 对多（视频-剪辑）：`clips.source_video_id` → `videos.id`

### 2.3 `video_category`
视频与分类的多对多关联表。

- 主键：联合主键 (`video_id`, `category_id`)
- 字段：
  - `video_id`（FK → `videos.id`）
  - `category_id`（FK → `categories.id`）

### 2.4 `clips`
视频剪辑资源（继承自 `resources`）。

- 主键：`id`（PK，同时 FK → `resources.id`）
- 字段：
  - `id` (PK/FK)
  - `start_time`
  - `end_time`
  - `clip_duration`
  - `clip_method`
  - `generated_by`（可空）
  - `source_video_id`（FK → `videos.id`，不可空）

---

## 3. 用户、互动与进度

### 3.1 `users`
用户主表（RBAC 与资源/路径关联的主体）。

- 主键：`id`
- 字段（模型定义）：
  - `id` (PK)
  - `username`（唯一，索引）
  - `email`（唯一，索引）
  - `hashed_password`
  - `display_name`（可空）
  - `avatar_url`（可空）
  - `bio`（可空）
  - `created_at`
  - `updated_at`
  - `is_active`
  - `is_superuser`
- 关系：
  - 多对多（用户-学习路径）：通过 `user_learning_paths`
  - 多对多（用户-资源）：通过 `user_resource`
  - 多对多（用户-视频）：通过 `user_video`
  - 1 对多（用户-观看记录）：`watch_history.user_id` → `users.id`
  - RBAC：通过 `user_roles`（见 4.1）

### 3.2 `user_video`
用户与视频的关联表（带额外属性）。

- 主键：联合主键 (`user_id`, `video_id`)
- 字段：
  - `user_id`（FK → `users.id`）
  - `video_id`（FK → `videos.id`）
  - `liked`
  - `views_count`
  - `is_public`
  - `status`

### 3.3 `watch_history`
用户观看视频历史。

- 主键：`id`
- 字段：
  - `id` (PK)
  - `user_id`（FK → `users.id`）
  - `video_id`（FK → `videos.id`）
  - `watch_time`
  - `is_watched`

### 3.4 `progress`
学习进度（按 `path_items` 粒度记录）。

- 主键：`id`
- 字段：
  - `id` (PK)
  - `user_id`（FK → `users.id`）
  - `path_item_id`（FK → `path_items.id`）
  - `last_watched_time`
  - `progress_percentage`

> 备注：`path_progress.py` 目前为空文件，不对应实际表。

---

## 4. RBAC（角色/权限）

### 4.1 `roles`
- 主键：`id`
- 字段：`name`(唯一), `code`(唯一), `description`, `is_active`, `is_system`, `level`, `created_at`, `updated_at`

### 4.2 `permissions`
- 主键：`id`
- 字段：`name`(唯一), `code`(唯一), `description`, `module`, `action`, `is_active`, `created_at`, `updated_at`

### 4.3 `user_roles`
用户与角色关联（带 `assigned_at`）。

- 主键：联合主键 (`user_id`, `role_id`)
- 字段：
  - `user_id`（FK → `users.id`）
  - `role_id`（FK → `roles.id`）
  - `assigned_at`

### 4.4 `role_permissions`
角色与权限关联（带 `granted_at`）。

- 主键：联合主键 (`role_id`, `permission_id`)
- 字段：
  - `role_id`（FK → `roles.id`）
  - `permission_id`（FK → `permissions.id`）
  - `granted_at`

---

## 5. 社交/互动（relations.py）

### 5.1 `user_video_likes`
- 主键：联合主键 (`user_id`, `video_id`)
- 字段：
  - `user_id`（FK → `users.id`）
  - `video_id`（FK → `videos.id`）
  - `like_type`（枚举）
  - `created_at`

### 5.2 `user_follows`
用户关注关系（自引用用户表）。

- 主键：联合主键 (`follower_id`, `following_id`)
- 字段：
  - `follower_id`（FK → `users.id`）
  - `following_id`（FK → `users.id`）
  - `created_at`

---

## 6. 其他（当前模型存在但与主流程关联较弱）

### 6.1 `docs`
文档表（独立实体，暂未在主流程中使用明显外键关联）。

- 主键：`id`
- 字段：`name`(唯一), `description`

### 6.2 `products`
产品表（独立实体）。

- 主键：`id`
- 字段：`name`(唯一), `description`

---

## 7. 关系速览（ER 口径）

- `categories (1) ← (N) categories`（自引用 parent/children）
- `categories (1) ← (N) resources`（`resources.category_id`）
- `categories (1) ← (N) learning_paths`（`learning_paths.category_id`）
- `learning_paths (1) ← (N) path_items`（`path_items.learning_path_id`）
- `resources (1) ← (N) path_items`（`path_items.resource_id`）
- `users (N) ↔ (N) learning_paths`（`user_learning_paths`）
- `users (N) ↔ (N) resources`（`user_resource`）
- `resources (1) ↔ (1) link_resources|videos|clips`（继承子表）
- `videos (N) ↔ (N) categories`（`video_category`）
- `users (N) ↔ (N) videos`（`user_video`）
- `users (1) ← (N) watch_history`，`videos (1) ← (N) watch_history`
- `users (1) ← (N) progress`，`path_items (1) ← (N) progress`
- `users (N) ↔ (N) roles`（`user_roles`）
- `roles (N) ↔ (N) permissions`（`role_permissions`）

---

## 8. 迁移（Alembic）索引

- `20260111_0001`：`link_resources`、`user_resource`（以及对 `resources` 增补 timestamps）
- `20260117_0002`：`resources.is_public`
- `20260118_0003`：`categories`、`learning_paths.category_id`
- `20260118_0004`：`resources.category_id`
