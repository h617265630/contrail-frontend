drop extension if exists "pg_net";

create type "public"."liketype" as enum ('LIKE', 'LOVE', 'HAHA', 'WOW', 'SAD', 'ANGRY');

create type "public"."resourcetype" as enum ('VIDEO', 'CLIP', 'link', 'document', 'article', 'video', 'clip');

create sequence "public"."ai_workflow_paths_id_seq";

create sequence "public"."categories_id_seq";

create sequence "public"."docs_id_seq";

create sequence "public"."learning_path_comments_id_seq";

create sequence "public"."learning_paths_id_seq";

create sequence "public"."path_items_id_seq";

create sequence "public"."permissions_id_seq";

create sequence "public"."products_id_seq";

create sequence "public"."progress_id_seq";

create sequence "public"."resources_id_seq";

create sequence "public"."roles_id_seq";

create sequence "public"."subscriptions_id_seq";

create sequence "public"."user_files_id_seq";

create sequence "public"."user_images_id_seq";

create sequence "public"."users_id_seq";

create sequence "public"."webhook_events_id_seq";


  create table "public"."ai_workflow_paths" (
    "id" integer not null default nextval('public.ai_workflow_paths_id_seq'::regclass),
    "user_id" integer,
    "topic" character varying(500) not null,
    "title" character varying(500),
    "description" text,
    "raw_data" json,
    "difficulty" character varying(50),
    "estimated_duration" character varying(100),
    "stages_json" json,
    "template_id" integer,
    "workflow_stages" json,
    "is_saved" boolean,
    "is_public" boolean,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone
      );



  create table "public"."alembic_version" (
    "version_num" character varying(128) not null
      );



  create table "public"."articles" (
    "resource_id" integer not null,
    "publisher" character varying(255),
    "published_at" timestamp without time zone
      );



  create table "public"."categories" (
    "id" integer not null default nextval('public.categories_id_seq'::regclass),
    "name" character varying(100) not null,
    "code" character varying(50) not null,
    "parent_id" integer,
    "level" integer,
    "description" text,
    "is_leaf" boolean,
    "created_at" timestamp without time zone,
    "is_system" boolean not null default true,
    "owner_user_id" integer
      );



  create table "public"."docs" (
    "resource_id" integer not null,
    "doc_type" character varying(50),
    "version" character varying(50)
      );



  create table "public"."docs_legacy" (
    "id" integer not null default nextval('public.docs_id_seq'::regclass),
    "name" character varying(100) not null,
    "description" text
      );



  create table "public"."learning_path_comments" (
    "id" integer not null default nextval('public.learning_path_comments_id_seq'::regclass),
    "learning_path_id" integer not null,
    "user_id" integer not null,
    "username" character varying(64) not null,
    "content" text not null,
    "created_at" timestamp with time zone not null default now()
      );



  create table "public"."learning_paths" (
    "id" integer not null default nextval('public.learning_paths_id_seq'::regclass),
    "title" character varying(200) not null,
    "description" text,
    "is_public" boolean,
    "is_active" boolean,
    "category_id" integer not null,
    "cover_image_url" character varying(2048),
    "type" character varying(50)
      );



  create table "public"."path_items" (
    "id" integer not null default nextval('public.path_items_id_seq'::regclass),
    "learning_path_id" integer not null,
    "resource_id" integer not null,
    "order_index" integer not null,
    "stage" character varying(100),
    "purpose" character varying(255),
    "estimated_time" integer,
    "is_optional" boolean not null default false
      );



  create table "public"."permissions" (
    "id" integer not null default nextval('public.permissions_id_seq'::regclass),
    "name" character varying(100) not null,
    "code" character varying(100) not null,
    "description" text,
    "module" character varying(50) not null,
    "action" character varying(50) not null,
    "is_active" boolean,
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone
      );



  create table "public"."products" (
    "id" integer not null default nextval('public.products_id_seq'::regclass),
    "name" character varying(100) not null,
    "description" text
      );



  create table "public"."progress" (
    "id" integer not null default nextval('public.progress_id_seq'::regclass),
    "user_id" integer,
    "path_item_id" integer,
    "last_watched_time" timestamp without time zone,
    "progress_percentage" integer
      );



  create table "public"."resources" (
    "id" integer not null default nextval('public.resources_id_seq'::regclass),
    "resource_type" public.resourcetype not null,
    "platform" character varying(50),
    "title" character varying(500) not null,
    "summary" text,
    "source_url" character varying(2048) not null,
    "thumbnail" character varying(1000),
    "difficulty" integer,
    "tags" json,
    "raw_meta" json,
    "created_at" timestamp without time zone not null default now(),
    "category_id" integer not null,
    "is_system_public" boolean not null default false,
    "community_score" integer not null default 0,
    "save_count" integer not null default 0,
    "trending_score" integer not null default 0
      );



  create table "public"."role_permissions" (
    "role_id" integer not null,
    "permission_id" integer not null,
    "granted_at" timestamp without time zone
      );



  create table "public"."roles" (
    "id" integer not null default nextval('public.roles_id_seq'::regclass),
    "name" character varying(50) not null,
    "code" character varying(50) not null,
    "description" text,
    "is_active" boolean,
    "is_system" boolean,
    "level" integer,
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone
      );



  create table "public"."subscriptions" (
    "id" integer not null default nextval('public.subscriptions_id_seq'::regclass),
    "user_id" integer not null,
    "provider" character varying(50) not null,
    "provider_subscription_id" character varying(128),
    "plan_code" character varying(50) not null,
    "status" character varying(32) not null,
    "current_period_start" timestamp without time zone,
    "current_period_end" timestamp without time zone,
    "cancel_at_period_end" boolean not null,
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone
      );



  create table "public"."user_files" (
    "id" integer not null default nextval('public.user_files_id_seq'::regclass),
    "user_id" integer not null,
    "title" character varying(200),
    "file_type" character varying(20) not null,
    "original_filename" character varying(512),
    "content_type" character varying(200),
    "size_bytes" integer,
    "file_url" character varying(2048) not null,
    "created_at" timestamp without time zone,
    "content" text
      );



  create table "public"."user_follows" (
    "follower_id" integer not null,
    "following_id" integer not null,
    "created_at" timestamp without time zone
      );



  create table "public"."user_images" (
    "id" integer not null default nextval('public.user_images_id_seq'::regclass),
    "user_id" integer not null,
    "title" character varying(200),
    "image_url" character varying(2048) not null,
    "created_at" timestamp without time zone
      );



  create table "public"."user_learning_paths" (
    "user_id" integer not null,
    "learning_path_id" integer not null
      );



  create table "public"."user_resource" (
    "user_id" integer not null,
    "resource_id" integer not null,
    "created_at" timestamp without time zone not null default now(),
    "is_public" boolean,
    "manual_weight" integer,
    "behavior_weight" integer,
    "effective_weight" integer,
    "added_at" timestamp without time zone,
    "last_opened" timestamp without time zone,
    "open_count" integer not null default 0,
    "completion_status" boolean not null default false
      );



  create table "public"."user_roles" (
    "user_id" integer not null,
    "role_id" integer not null,
    "assigned_at" timestamp without time zone
      );



  create table "public"."users" (
    "id" integer not null default nextval('public.users_id_seq'::regclass),
    "username" character varying(50) not null,
    "email" character varying(120) not null,
    "hashed_password" character varying(255) not null,
    "display_name" character varying(100),
    "avatar_url" character varying(500),
    "bio" text,
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone,
    "is_active" boolean,
    "is_superuser" boolean
      );



  create table "public"."videos" (
    "resource_id" integer not null,
    "duration" integer,
    "channel" character varying(255),
    "video_id" character varying(100)
      );



  create table "public"."webhook_events" (
    "id" integer not null default nextval('public.webhook_events_id_seq'::regclass),
    "provider" character varying(50) not null,
    "event_id" character varying(128),
    "event_type" character varying(128),
    "payload_json" text not null,
    "headers_json" text not null,
    "received_at" timestamp without time zone not null,
    "processed" boolean not null,
    "error" text
      );


alter sequence "public"."ai_workflow_paths_id_seq" owned by "public"."ai_workflow_paths"."id";

alter sequence "public"."categories_id_seq" owned by "public"."categories"."id";

alter sequence "public"."docs_id_seq" owned by "public"."docs_legacy"."id";

alter sequence "public"."learning_path_comments_id_seq" owned by "public"."learning_path_comments"."id";

alter sequence "public"."learning_paths_id_seq" owned by "public"."learning_paths"."id";

alter sequence "public"."path_items_id_seq" owned by "public"."path_items"."id";

alter sequence "public"."permissions_id_seq" owned by "public"."permissions"."id";

alter sequence "public"."products_id_seq" owned by "public"."products"."id";

alter sequence "public"."progress_id_seq" owned by "public"."progress"."id";

alter sequence "public"."resources_id_seq" owned by "public"."resources"."id";

alter sequence "public"."roles_id_seq" owned by "public"."roles"."id";

alter sequence "public"."subscriptions_id_seq" owned by "public"."subscriptions"."id";

alter sequence "public"."user_files_id_seq" owned by "public"."user_files"."id";

alter sequence "public"."user_images_id_seq" owned by "public"."user_images"."id";

alter sequence "public"."users_id_seq" owned by "public"."users"."id";

alter sequence "public"."webhook_events_id_seq" owned by "public"."webhook_events"."id";

CREATE UNIQUE INDEX ai_workflow_paths_pkey ON public.ai_workflow_paths USING btree (id);

CREATE UNIQUE INDEX alembic_version_pkc ON public.alembic_version USING btree (version_num);

CREATE UNIQUE INDEX articles_pkey ON public.articles USING btree (resource_id);

CREATE UNIQUE INDEX categories_pkey ON public.categories USING btree (id);

CREATE UNIQUE INDEX docs_pkey ON public.docs_legacy USING btree (id);

CREATE UNIQUE INDEX docs_pkey1 ON public.docs USING btree (resource_id);

CREATE INDEX ix_ai_workflow_paths_id ON public.ai_workflow_paths USING btree (id);

CREATE UNIQUE INDEX ix_categories_code ON public.categories USING btree (code);

CREATE INDEX ix_categories_id ON public.categories USING btree (id);

CREATE UNIQUE INDEX ix_categories_name ON public.categories USING btree (name);

CREATE INDEX ix_docs_id ON public.docs_legacy USING btree (id);

CREATE UNIQUE INDEX ix_docs_name ON public.docs_legacy USING btree (name);

CREATE INDEX ix_learning_path_comments_id ON public.learning_path_comments USING btree (id);

CREATE INDEX ix_learning_path_comments_learning_path_id ON public.learning_path_comments USING btree (learning_path_id);

CREATE INDEX ix_learning_path_comments_user_id ON public.learning_path_comments USING btree (user_id);

CREATE INDEX ix_learning_paths_category_id ON public.learning_paths USING btree (category_id);

CREATE INDEX ix_learning_paths_id ON public.learning_paths USING btree (id);

CREATE INDEX ix_path_items_learning_path_id ON public.path_items USING btree (learning_path_id);

CREATE INDEX ix_path_items_resource_id ON public.path_items USING btree (resource_id);

CREATE UNIQUE INDEX ix_permissions_code ON public.permissions USING btree (code);

CREATE INDEX ix_permissions_id ON public.permissions USING btree (id);

CREATE UNIQUE INDEX ix_permissions_name ON public.permissions USING btree (name);

CREATE INDEX ix_products_id ON public.products USING btree (id);

CREATE UNIQUE INDEX ix_products_name ON public.products USING btree (name);

CREATE INDEX ix_resources_category_id ON public.resources USING btree (category_id);

CREATE INDEX ix_resources_platform ON public.resources USING btree (platform);

CREATE INDEX ix_resources_resource_type ON public.resources USING btree (resource_type);

CREATE UNIQUE INDEX ix_roles_code ON public.roles USING btree (code);

CREATE INDEX ix_roles_id ON public.roles USING btree (id);

CREATE UNIQUE INDEX ix_roles_name ON public.roles USING btree (name);

CREATE INDEX ix_subscriptions_id ON public.subscriptions USING btree (id);

CREATE UNIQUE INDEX ix_subscriptions_provider_subscription_id ON public.subscriptions USING btree (provider_subscription_id);

CREATE INDEX ix_subscriptions_user_id ON public.subscriptions USING btree (user_id);

CREATE INDEX ix_user_files_id ON public.user_files USING btree (id);

CREATE INDEX ix_user_files_user_id ON public.user_files USING btree (user_id);

CREATE INDEX ix_user_images_id ON public.user_images USING btree (id);

CREATE INDEX ix_user_images_user_id ON public.user_images USING btree (user_id);

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);

CREATE INDEX ix_users_id ON public.users USING btree (id);

CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);

CREATE INDEX ix_videos_video_id ON public.videos USING btree (video_id);

CREATE INDEX ix_webhook_events_event_id ON public.webhook_events USING btree (event_id);

CREATE INDEX ix_webhook_events_event_type ON public.webhook_events USING btree (event_type);

CREATE INDEX ix_webhook_events_id ON public.webhook_events USING btree (id);

CREATE UNIQUE INDEX learning_path_comments_pkey ON public.learning_path_comments USING btree (id);

CREATE UNIQUE INDEX learning_paths_pkey ON public.learning_paths USING btree (id);

CREATE UNIQUE INDEX path_items_pkey ON public.path_items USING btree (id);

CREATE UNIQUE INDEX permissions_pkey ON public.permissions USING btree (id);

CREATE UNIQUE INDEX products_pkey ON public.products USING btree (id);

CREATE UNIQUE INDEX progress_pkey ON public.progress USING btree (id);

CREATE UNIQUE INDEX resources_pkey ON public.resources USING btree (id);

CREATE UNIQUE INDEX role_permissions_pkey ON public.role_permissions USING btree (role_id, permission_id);

CREATE UNIQUE INDEX roles_pkey ON public.roles USING btree (id);

CREATE UNIQUE INDEX subscriptions_pkey ON public.subscriptions USING btree (id);

CREATE UNIQUE INDEX uq_learning_path_order ON public.path_items USING btree (learning_path_id, order_index);

CREATE UNIQUE INDEX uq_learning_path_resource ON public.path_items USING btree (learning_path_id, resource_id);

CREATE UNIQUE INDEX uq_subscription_user_provider ON public.subscriptions USING btree (user_id, provider);

CREATE UNIQUE INDEX uq_user_resource ON public.user_resource USING btree (user_id, resource_id);

CREATE UNIQUE INDEX user_files_pkey ON public.user_files USING btree (id);

CREATE UNIQUE INDEX user_follows_pkey ON public.user_follows USING btree (follower_id, following_id);

CREATE UNIQUE INDEX user_images_pkey ON public.user_images USING btree (id);

CREATE UNIQUE INDEX user_learning_paths_pkey ON public.user_learning_paths USING btree (user_id, learning_path_id);

CREATE UNIQUE INDEX user_roles_pkey ON public.user_roles USING btree (user_id, role_id);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

CREATE UNIQUE INDEX videos_pkey ON public.videos USING btree (resource_id);

CREATE UNIQUE INDEX webhook_events_pkey ON public.webhook_events USING btree (id);

alter table "public"."ai_workflow_paths" add constraint "ai_workflow_paths_pkey" PRIMARY KEY using index "ai_workflow_paths_pkey";

alter table "public"."alembic_version" add constraint "alembic_version_pkc" PRIMARY KEY using index "alembic_version_pkc";

alter table "public"."articles" add constraint "articles_pkey" PRIMARY KEY using index "articles_pkey";

alter table "public"."categories" add constraint "categories_pkey" PRIMARY KEY using index "categories_pkey";

alter table "public"."docs" add constraint "docs_pkey1" PRIMARY KEY using index "docs_pkey1";

alter table "public"."docs_legacy" add constraint "docs_pkey" PRIMARY KEY using index "docs_pkey";

alter table "public"."learning_path_comments" add constraint "learning_path_comments_pkey" PRIMARY KEY using index "learning_path_comments_pkey";

alter table "public"."learning_paths" add constraint "learning_paths_pkey" PRIMARY KEY using index "learning_paths_pkey";

alter table "public"."path_items" add constraint "path_items_pkey" PRIMARY KEY using index "path_items_pkey";

alter table "public"."permissions" add constraint "permissions_pkey" PRIMARY KEY using index "permissions_pkey";

alter table "public"."products" add constraint "products_pkey" PRIMARY KEY using index "products_pkey";

alter table "public"."progress" add constraint "progress_pkey" PRIMARY KEY using index "progress_pkey";

alter table "public"."resources" add constraint "resources_pkey" PRIMARY KEY using index "resources_pkey";

alter table "public"."role_permissions" add constraint "role_permissions_pkey" PRIMARY KEY using index "role_permissions_pkey";

alter table "public"."roles" add constraint "roles_pkey" PRIMARY KEY using index "roles_pkey";

alter table "public"."subscriptions" add constraint "subscriptions_pkey" PRIMARY KEY using index "subscriptions_pkey";

alter table "public"."user_files" add constraint "user_files_pkey" PRIMARY KEY using index "user_files_pkey";

alter table "public"."user_follows" add constraint "user_follows_pkey" PRIMARY KEY using index "user_follows_pkey";

alter table "public"."user_images" add constraint "user_images_pkey" PRIMARY KEY using index "user_images_pkey";

alter table "public"."user_learning_paths" add constraint "user_learning_paths_pkey" PRIMARY KEY using index "user_learning_paths_pkey";

alter table "public"."user_resource" add constraint "uq_user_resource" PRIMARY KEY using index "uq_user_resource";

alter table "public"."user_roles" add constraint "user_roles_pkey" PRIMARY KEY using index "user_roles_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."videos" add constraint "videos_pkey" PRIMARY KEY using index "videos_pkey";

alter table "public"."webhook_events" add constraint "webhook_events_pkey" PRIMARY KEY using index "webhook_events_pkey";

alter table "public"."ai_workflow_paths" add constraint "ai_workflow_paths_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."ai_workflow_paths" validate constraint "ai_workflow_paths_user_id_fkey";

alter table "public"."articles" add constraint "articles_resource_id_fkey" FOREIGN KEY (resource_id) REFERENCES public.resources(id) ON DELETE CASCADE not valid;

alter table "public"."articles" validate constraint "articles_resource_id_fkey";

alter table "public"."categories" add constraint "categories_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES public.categories(id) not valid;

alter table "public"."categories" validate constraint "categories_parent_id_fkey";

alter table "public"."categories" add constraint "fk_categories_owner_user_id_users" FOREIGN KEY (owner_user_id) REFERENCES public.users(id) not valid;

alter table "public"."categories" validate constraint "fk_categories_owner_user_id_users";

alter table "public"."docs" add constraint "docs_resource_id_fkey" FOREIGN KEY (resource_id) REFERENCES public.resources(id) ON DELETE CASCADE not valid;

alter table "public"."docs" validate constraint "docs_resource_id_fkey";

alter table "public"."learning_path_comments" add constraint "learning_path_comments_learning_path_id_fkey" FOREIGN KEY (learning_path_id) REFERENCES public.learning_paths(id) not valid;

alter table "public"."learning_path_comments" validate constraint "learning_path_comments_learning_path_id_fkey";

alter table "public"."learning_path_comments" add constraint "learning_path_comments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."learning_path_comments" validate constraint "learning_path_comments_user_id_fkey";

alter table "public"."learning_paths" add constraint "fk_learning_paths_category_id_categories" FOREIGN KEY (category_id) REFERENCES public.categories(id) not valid;

alter table "public"."learning_paths" validate constraint "fk_learning_paths_category_id_categories";

alter table "public"."path_items" add constraint "path_items_learning_path_id_fkey" FOREIGN KEY (learning_path_id) REFERENCES public.learning_paths(id) ON DELETE CASCADE not valid;

alter table "public"."path_items" validate constraint "path_items_learning_path_id_fkey";

alter table "public"."path_items" add constraint "path_items_resource_id_fkey" FOREIGN KEY (resource_id) REFERENCES public.resources(id) ON DELETE CASCADE not valid;

alter table "public"."path_items" validate constraint "path_items_resource_id_fkey";

alter table "public"."path_items" add constraint "uq_learning_path_order" UNIQUE using index "uq_learning_path_order";

alter table "public"."path_items" add constraint "uq_learning_path_resource" UNIQUE using index "uq_learning_path_resource";

alter table "public"."progress" add constraint "progress_path_item_id_fkey" FOREIGN KEY (path_item_id) REFERENCES public.path_items(id) ON DELETE CASCADE not valid;

alter table "public"."progress" validate constraint "progress_path_item_id_fkey";

alter table "public"."progress" add constraint "progress_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."progress" validate constraint "progress_user_id_fkey";

alter table "public"."resources" add constraint "fk_resources_category_id_categories" FOREIGN KEY (category_id) REFERENCES public.categories(id) not valid;

alter table "public"."resources" validate constraint "fk_resources_category_id_categories";

alter table "public"."role_permissions" add constraint "role_permissions_permission_id_fkey" FOREIGN KEY (permission_id) REFERENCES public.permissions(id) not valid;

alter table "public"."role_permissions" validate constraint "role_permissions_permission_id_fkey";

alter table "public"."role_permissions" add constraint "role_permissions_role_id_fkey" FOREIGN KEY (role_id) REFERENCES public.roles(id) not valid;

alter table "public"."role_permissions" validate constraint "role_permissions_role_id_fkey";

alter table "public"."subscriptions" add constraint "subscriptions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."subscriptions" validate constraint "subscriptions_user_id_fkey";

alter table "public"."subscriptions" add constraint "uq_subscription_user_provider" UNIQUE using index "uq_subscription_user_provider";

alter table "public"."user_files" add constraint "user_files_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."user_files" validate constraint "user_files_user_id_fkey";

alter table "public"."user_follows" add constraint "user_follows_follower_id_fkey" FOREIGN KEY (follower_id) REFERENCES public.users(id) not valid;

alter table "public"."user_follows" validate constraint "user_follows_follower_id_fkey";

alter table "public"."user_follows" add constraint "user_follows_following_id_fkey" FOREIGN KEY (following_id) REFERENCES public.users(id) not valid;

alter table "public"."user_follows" validate constraint "user_follows_following_id_fkey";

alter table "public"."user_images" add constraint "user_images_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."user_images" validate constraint "user_images_user_id_fkey";

alter table "public"."user_learning_paths" add constraint "user_learning_paths_learning_path_id_fkey" FOREIGN KEY (learning_path_id) REFERENCES public.learning_paths(id) not valid;

alter table "public"."user_learning_paths" validate constraint "user_learning_paths_learning_path_id_fkey";

alter table "public"."user_learning_paths" add constraint "user_learning_paths_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."user_learning_paths" validate constraint "user_learning_paths_user_id_fkey";

alter table "public"."user_resource" add constraint "user_resource_resource_id_fkey" FOREIGN KEY (resource_id) REFERENCES public.resources(id) not valid;

alter table "public"."user_resource" validate constraint "user_resource_resource_id_fkey";

alter table "public"."user_resource" add constraint "user_resource_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."user_resource" validate constraint "user_resource_user_id_fkey";

alter table "public"."user_roles" add constraint "user_roles_role_id_fkey" FOREIGN KEY (role_id) REFERENCES public.roles(id) not valid;

alter table "public"."user_roles" validate constraint "user_roles_role_id_fkey";

alter table "public"."user_roles" add constraint "user_roles_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."user_roles" validate constraint "user_roles_user_id_fkey";

alter table "public"."videos" add constraint "videos_resource_id_fkey" FOREIGN KEY (resource_id) REFERENCES public.resources(id) ON DELETE CASCADE not valid;

alter table "public"."videos" validate constraint "videos_resource_id_fkey";

grant delete on table "public"."ai_workflow_paths" to "anon";

grant insert on table "public"."ai_workflow_paths" to "anon";

grant references on table "public"."ai_workflow_paths" to "anon";

grant select on table "public"."ai_workflow_paths" to "anon";

grant trigger on table "public"."ai_workflow_paths" to "anon";

grant truncate on table "public"."ai_workflow_paths" to "anon";

grant update on table "public"."ai_workflow_paths" to "anon";

grant delete on table "public"."ai_workflow_paths" to "authenticated";

grant insert on table "public"."ai_workflow_paths" to "authenticated";

grant references on table "public"."ai_workflow_paths" to "authenticated";

grant select on table "public"."ai_workflow_paths" to "authenticated";

grant trigger on table "public"."ai_workflow_paths" to "authenticated";

grant truncate on table "public"."ai_workflow_paths" to "authenticated";

grant update on table "public"."ai_workflow_paths" to "authenticated";

grant delete on table "public"."ai_workflow_paths" to "service_role";

grant insert on table "public"."ai_workflow_paths" to "service_role";

grant references on table "public"."ai_workflow_paths" to "service_role";

grant select on table "public"."ai_workflow_paths" to "service_role";

grant trigger on table "public"."ai_workflow_paths" to "service_role";

grant truncate on table "public"."ai_workflow_paths" to "service_role";

grant update on table "public"."ai_workflow_paths" to "service_role";

grant delete on table "public"."alembic_version" to "anon";

grant insert on table "public"."alembic_version" to "anon";

grant references on table "public"."alembic_version" to "anon";

grant select on table "public"."alembic_version" to "anon";

grant trigger on table "public"."alembic_version" to "anon";

grant truncate on table "public"."alembic_version" to "anon";

grant update on table "public"."alembic_version" to "anon";

grant delete on table "public"."alembic_version" to "authenticated";

grant insert on table "public"."alembic_version" to "authenticated";

grant references on table "public"."alembic_version" to "authenticated";

grant select on table "public"."alembic_version" to "authenticated";

grant trigger on table "public"."alembic_version" to "authenticated";

grant truncate on table "public"."alembic_version" to "authenticated";

grant update on table "public"."alembic_version" to "authenticated";

grant delete on table "public"."alembic_version" to "service_role";

grant insert on table "public"."alembic_version" to "service_role";

grant references on table "public"."alembic_version" to "service_role";

grant select on table "public"."alembic_version" to "service_role";

grant trigger on table "public"."alembic_version" to "service_role";

grant truncate on table "public"."alembic_version" to "service_role";

grant update on table "public"."alembic_version" to "service_role";

grant delete on table "public"."articles" to "anon";

grant insert on table "public"."articles" to "anon";

grant references on table "public"."articles" to "anon";

grant select on table "public"."articles" to "anon";

grant trigger on table "public"."articles" to "anon";

grant truncate on table "public"."articles" to "anon";

grant update on table "public"."articles" to "anon";

grant delete on table "public"."articles" to "authenticated";

grant insert on table "public"."articles" to "authenticated";

grant references on table "public"."articles" to "authenticated";

grant select on table "public"."articles" to "authenticated";

grant trigger on table "public"."articles" to "authenticated";

grant truncate on table "public"."articles" to "authenticated";

grant update on table "public"."articles" to "authenticated";

grant delete on table "public"."articles" to "service_role";

grant insert on table "public"."articles" to "service_role";

grant references on table "public"."articles" to "service_role";

grant select on table "public"."articles" to "service_role";

grant trigger on table "public"."articles" to "service_role";

grant truncate on table "public"."articles" to "service_role";

grant update on table "public"."articles" to "service_role";

grant delete on table "public"."categories" to "anon";

grant insert on table "public"."categories" to "anon";

grant references on table "public"."categories" to "anon";

grant select on table "public"."categories" to "anon";

grant trigger on table "public"."categories" to "anon";

grant truncate on table "public"."categories" to "anon";

grant update on table "public"."categories" to "anon";

grant delete on table "public"."categories" to "authenticated";

grant insert on table "public"."categories" to "authenticated";

grant references on table "public"."categories" to "authenticated";

grant select on table "public"."categories" to "authenticated";

grant trigger on table "public"."categories" to "authenticated";

grant truncate on table "public"."categories" to "authenticated";

grant update on table "public"."categories" to "authenticated";

grant delete on table "public"."categories" to "service_role";

grant insert on table "public"."categories" to "service_role";

grant references on table "public"."categories" to "service_role";

grant select on table "public"."categories" to "service_role";

grant trigger on table "public"."categories" to "service_role";

grant truncate on table "public"."categories" to "service_role";

grant update on table "public"."categories" to "service_role";

grant delete on table "public"."docs" to "anon";

grant insert on table "public"."docs" to "anon";

grant references on table "public"."docs" to "anon";

grant select on table "public"."docs" to "anon";

grant trigger on table "public"."docs" to "anon";

grant truncate on table "public"."docs" to "anon";

grant update on table "public"."docs" to "anon";

grant delete on table "public"."docs" to "authenticated";

grant insert on table "public"."docs" to "authenticated";

grant references on table "public"."docs" to "authenticated";

grant select on table "public"."docs" to "authenticated";

grant trigger on table "public"."docs" to "authenticated";

grant truncate on table "public"."docs" to "authenticated";

grant update on table "public"."docs" to "authenticated";

grant delete on table "public"."docs" to "service_role";

grant insert on table "public"."docs" to "service_role";

grant references on table "public"."docs" to "service_role";

grant select on table "public"."docs" to "service_role";

grant trigger on table "public"."docs" to "service_role";

grant truncate on table "public"."docs" to "service_role";

grant update on table "public"."docs" to "service_role";

grant delete on table "public"."docs_legacy" to "anon";

grant insert on table "public"."docs_legacy" to "anon";

grant references on table "public"."docs_legacy" to "anon";

grant select on table "public"."docs_legacy" to "anon";

grant trigger on table "public"."docs_legacy" to "anon";

grant truncate on table "public"."docs_legacy" to "anon";

grant update on table "public"."docs_legacy" to "anon";

grant delete on table "public"."docs_legacy" to "authenticated";

grant insert on table "public"."docs_legacy" to "authenticated";

grant references on table "public"."docs_legacy" to "authenticated";

grant select on table "public"."docs_legacy" to "authenticated";

grant trigger on table "public"."docs_legacy" to "authenticated";

grant truncate on table "public"."docs_legacy" to "authenticated";

grant update on table "public"."docs_legacy" to "authenticated";

grant delete on table "public"."docs_legacy" to "service_role";

grant insert on table "public"."docs_legacy" to "service_role";

grant references on table "public"."docs_legacy" to "service_role";

grant select on table "public"."docs_legacy" to "service_role";

grant trigger on table "public"."docs_legacy" to "service_role";

grant truncate on table "public"."docs_legacy" to "service_role";

grant update on table "public"."docs_legacy" to "service_role";

grant delete on table "public"."learning_path_comments" to "anon";

grant insert on table "public"."learning_path_comments" to "anon";

grant references on table "public"."learning_path_comments" to "anon";

grant select on table "public"."learning_path_comments" to "anon";

grant trigger on table "public"."learning_path_comments" to "anon";

grant truncate on table "public"."learning_path_comments" to "anon";

grant update on table "public"."learning_path_comments" to "anon";

grant delete on table "public"."learning_path_comments" to "authenticated";

grant insert on table "public"."learning_path_comments" to "authenticated";

grant references on table "public"."learning_path_comments" to "authenticated";

grant select on table "public"."learning_path_comments" to "authenticated";

grant trigger on table "public"."learning_path_comments" to "authenticated";

grant truncate on table "public"."learning_path_comments" to "authenticated";

grant update on table "public"."learning_path_comments" to "authenticated";

grant delete on table "public"."learning_path_comments" to "service_role";

grant insert on table "public"."learning_path_comments" to "service_role";

grant references on table "public"."learning_path_comments" to "service_role";

grant select on table "public"."learning_path_comments" to "service_role";

grant trigger on table "public"."learning_path_comments" to "service_role";

grant truncate on table "public"."learning_path_comments" to "service_role";

grant update on table "public"."learning_path_comments" to "service_role";

grant delete on table "public"."learning_paths" to "anon";

grant insert on table "public"."learning_paths" to "anon";

grant references on table "public"."learning_paths" to "anon";

grant select on table "public"."learning_paths" to "anon";

grant trigger on table "public"."learning_paths" to "anon";

grant truncate on table "public"."learning_paths" to "anon";

grant update on table "public"."learning_paths" to "anon";

grant delete on table "public"."learning_paths" to "authenticated";

grant insert on table "public"."learning_paths" to "authenticated";

grant references on table "public"."learning_paths" to "authenticated";

grant select on table "public"."learning_paths" to "authenticated";

grant trigger on table "public"."learning_paths" to "authenticated";

grant truncate on table "public"."learning_paths" to "authenticated";

grant update on table "public"."learning_paths" to "authenticated";

grant delete on table "public"."learning_paths" to "service_role";

grant insert on table "public"."learning_paths" to "service_role";

grant references on table "public"."learning_paths" to "service_role";

grant select on table "public"."learning_paths" to "service_role";

grant trigger on table "public"."learning_paths" to "service_role";

grant truncate on table "public"."learning_paths" to "service_role";

grant update on table "public"."learning_paths" to "service_role";

grant delete on table "public"."path_items" to "anon";

grant insert on table "public"."path_items" to "anon";

grant references on table "public"."path_items" to "anon";

grant select on table "public"."path_items" to "anon";

grant trigger on table "public"."path_items" to "anon";

grant truncate on table "public"."path_items" to "anon";

grant update on table "public"."path_items" to "anon";

grant delete on table "public"."path_items" to "authenticated";

grant insert on table "public"."path_items" to "authenticated";

grant references on table "public"."path_items" to "authenticated";

grant select on table "public"."path_items" to "authenticated";

grant trigger on table "public"."path_items" to "authenticated";

grant truncate on table "public"."path_items" to "authenticated";

grant update on table "public"."path_items" to "authenticated";

grant delete on table "public"."path_items" to "service_role";

grant insert on table "public"."path_items" to "service_role";

grant references on table "public"."path_items" to "service_role";

grant select on table "public"."path_items" to "service_role";

grant trigger on table "public"."path_items" to "service_role";

grant truncate on table "public"."path_items" to "service_role";

grant update on table "public"."path_items" to "service_role";

grant delete on table "public"."permissions" to "anon";

grant insert on table "public"."permissions" to "anon";

grant references on table "public"."permissions" to "anon";

grant select on table "public"."permissions" to "anon";

grant trigger on table "public"."permissions" to "anon";

grant truncate on table "public"."permissions" to "anon";

grant update on table "public"."permissions" to "anon";

grant delete on table "public"."permissions" to "authenticated";

grant insert on table "public"."permissions" to "authenticated";

grant references on table "public"."permissions" to "authenticated";

grant select on table "public"."permissions" to "authenticated";

grant trigger on table "public"."permissions" to "authenticated";

grant truncate on table "public"."permissions" to "authenticated";

grant update on table "public"."permissions" to "authenticated";

grant delete on table "public"."permissions" to "service_role";

grant insert on table "public"."permissions" to "service_role";

grant references on table "public"."permissions" to "service_role";

grant select on table "public"."permissions" to "service_role";

grant trigger on table "public"."permissions" to "service_role";

grant truncate on table "public"."permissions" to "service_role";

grant update on table "public"."permissions" to "service_role";

grant delete on table "public"."products" to "anon";

grant insert on table "public"."products" to "anon";

grant references on table "public"."products" to "anon";

grant select on table "public"."products" to "anon";

grant trigger on table "public"."products" to "anon";

grant truncate on table "public"."products" to "anon";

grant update on table "public"."products" to "anon";

grant delete on table "public"."products" to "authenticated";

grant insert on table "public"."products" to "authenticated";

grant references on table "public"."products" to "authenticated";

grant select on table "public"."products" to "authenticated";

grant trigger on table "public"."products" to "authenticated";

grant truncate on table "public"."products" to "authenticated";

grant update on table "public"."products" to "authenticated";

grant delete on table "public"."products" to "service_role";

grant insert on table "public"."products" to "service_role";

grant references on table "public"."products" to "service_role";

grant select on table "public"."products" to "service_role";

grant trigger on table "public"."products" to "service_role";

grant truncate on table "public"."products" to "service_role";

grant update on table "public"."products" to "service_role";

grant delete on table "public"."progress" to "anon";

grant insert on table "public"."progress" to "anon";

grant references on table "public"."progress" to "anon";

grant select on table "public"."progress" to "anon";

grant trigger on table "public"."progress" to "anon";

grant truncate on table "public"."progress" to "anon";

grant update on table "public"."progress" to "anon";

grant delete on table "public"."progress" to "authenticated";

grant insert on table "public"."progress" to "authenticated";

grant references on table "public"."progress" to "authenticated";

grant select on table "public"."progress" to "authenticated";

grant trigger on table "public"."progress" to "authenticated";

grant truncate on table "public"."progress" to "authenticated";

grant update on table "public"."progress" to "authenticated";

grant delete on table "public"."progress" to "service_role";

grant insert on table "public"."progress" to "service_role";

grant references on table "public"."progress" to "service_role";

grant select on table "public"."progress" to "service_role";

grant trigger on table "public"."progress" to "service_role";

grant truncate on table "public"."progress" to "service_role";

grant update on table "public"."progress" to "service_role";

grant delete on table "public"."resources" to "anon";

grant insert on table "public"."resources" to "anon";

grant references on table "public"."resources" to "anon";

grant select on table "public"."resources" to "anon";

grant trigger on table "public"."resources" to "anon";

grant truncate on table "public"."resources" to "anon";

grant update on table "public"."resources" to "anon";

grant delete on table "public"."resources" to "authenticated";

grant insert on table "public"."resources" to "authenticated";

grant references on table "public"."resources" to "authenticated";

grant select on table "public"."resources" to "authenticated";

grant trigger on table "public"."resources" to "authenticated";

grant truncate on table "public"."resources" to "authenticated";

grant update on table "public"."resources" to "authenticated";

grant delete on table "public"."resources" to "service_role";

grant insert on table "public"."resources" to "service_role";

grant references on table "public"."resources" to "service_role";

grant select on table "public"."resources" to "service_role";

grant trigger on table "public"."resources" to "service_role";

grant truncate on table "public"."resources" to "service_role";

grant update on table "public"."resources" to "service_role";

grant delete on table "public"."role_permissions" to "anon";

grant insert on table "public"."role_permissions" to "anon";

grant references on table "public"."role_permissions" to "anon";

grant select on table "public"."role_permissions" to "anon";

grant trigger on table "public"."role_permissions" to "anon";

grant truncate on table "public"."role_permissions" to "anon";

grant update on table "public"."role_permissions" to "anon";

grant delete on table "public"."role_permissions" to "authenticated";

grant insert on table "public"."role_permissions" to "authenticated";

grant references on table "public"."role_permissions" to "authenticated";

grant select on table "public"."role_permissions" to "authenticated";

grant trigger on table "public"."role_permissions" to "authenticated";

grant truncate on table "public"."role_permissions" to "authenticated";

grant update on table "public"."role_permissions" to "authenticated";

grant delete on table "public"."role_permissions" to "service_role";

grant insert on table "public"."role_permissions" to "service_role";

grant references on table "public"."role_permissions" to "service_role";

grant select on table "public"."role_permissions" to "service_role";

grant trigger on table "public"."role_permissions" to "service_role";

grant truncate on table "public"."role_permissions" to "service_role";

grant update on table "public"."role_permissions" to "service_role";

grant delete on table "public"."roles" to "anon";

grant insert on table "public"."roles" to "anon";

grant references on table "public"."roles" to "anon";

grant select on table "public"."roles" to "anon";

grant trigger on table "public"."roles" to "anon";

grant truncate on table "public"."roles" to "anon";

grant update on table "public"."roles" to "anon";

grant delete on table "public"."roles" to "authenticated";

grant insert on table "public"."roles" to "authenticated";

grant references on table "public"."roles" to "authenticated";

grant select on table "public"."roles" to "authenticated";

grant trigger on table "public"."roles" to "authenticated";

grant truncate on table "public"."roles" to "authenticated";

grant update on table "public"."roles" to "authenticated";

grant delete on table "public"."roles" to "service_role";

grant insert on table "public"."roles" to "service_role";

grant references on table "public"."roles" to "service_role";

grant select on table "public"."roles" to "service_role";

grant trigger on table "public"."roles" to "service_role";

grant truncate on table "public"."roles" to "service_role";

grant update on table "public"."roles" to "service_role";

grant delete on table "public"."subscriptions" to "anon";

grant insert on table "public"."subscriptions" to "anon";

grant references on table "public"."subscriptions" to "anon";

grant select on table "public"."subscriptions" to "anon";

grant trigger on table "public"."subscriptions" to "anon";

grant truncate on table "public"."subscriptions" to "anon";

grant update on table "public"."subscriptions" to "anon";

grant delete on table "public"."subscriptions" to "authenticated";

grant insert on table "public"."subscriptions" to "authenticated";

grant references on table "public"."subscriptions" to "authenticated";

grant select on table "public"."subscriptions" to "authenticated";

grant trigger on table "public"."subscriptions" to "authenticated";

grant truncate on table "public"."subscriptions" to "authenticated";

grant update on table "public"."subscriptions" to "authenticated";

grant delete on table "public"."subscriptions" to "service_role";

grant insert on table "public"."subscriptions" to "service_role";

grant references on table "public"."subscriptions" to "service_role";

grant select on table "public"."subscriptions" to "service_role";

grant trigger on table "public"."subscriptions" to "service_role";

grant truncate on table "public"."subscriptions" to "service_role";

grant update on table "public"."subscriptions" to "service_role";

grant delete on table "public"."user_files" to "anon";

grant insert on table "public"."user_files" to "anon";

grant references on table "public"."user_files" to "anon";

grant select on table "public"."user_files" to "anon";

grant trigger on table "public"."user_files" to "anon";

grant truncate on table "public"."user_files" to "anon";

grant update on table "public"."user_files" to "anon";

grant delete on table "public"."user_files" to "authenticated";

grant insert on table "public"."user_files" to "authenticated";

grant references on table "public"."user_files" to "authenticated";

grant select on table "public"."user_files" to "authenticated";

grant trigger on table "public"."user_files" to "authenticated";

grant truncate on table "public"."user_files" to "authenticated";

grant update on table "public"."user_files" to "authenticated";

grant delete on table "public"."user_files" to "service_role";

grant insert on table "public"."user_files" to "service_role";

grant references on table "public"."user_files" to "service_role";

grant select on table "public"."user_files" to "service_role";

grant trigger on table "public"."user_files" to "service_role";

grant truncate on table "public"."user_files" to "service_role";

grant update on table "public"."user_files" to "service_role";

grant delete on table "public"."user_follows" to "anon";

grant insert on table "public"."user_follows" to "anon";

grant references on table "public"."user_follows" to "anon";

grant select on table "public"."user_follows" to "anon";

grant trigger on table "public"."user_follows" to "anon";

grant truncate on table "public"."user_follows" to "anon";

grant update on table "public"."user_follows" to "anon";

grant delete on table "public"."user_follows" to "authenticated";

grant insert on table "public"."user_follows" to "authenticated";

grant references on table "public"."user_follows" to "authenticated";

grant select on table "public"."user_follows" to "authenticated";

grant trigger on table "public"."user_follows" to "authenticated";

grant truncate on table "public"."user_follows" to "authenticated";

grant update on table "public"."user_follows" to "authenticated";

grant delete on table "public"."user_follows" to "service_role";

grant insert on table "public"."user_follows" to "service_role";

grant references on table "public"."user_follows" to "service_role";

grant select on table "public"."user_follows" to "service_role";

grant trigger on table "public"."user_follows" to "service_role";

grant truncate on table "public"."user_follows" to "service_role";

grant update on table "public"."user_follows" to "service_role";

grant delete on table "public"."user_images" to "anon";

grant insert on table "public"."user_images" to "anon";

grant references on table "public"."user_images" to "anon";

grant select on table "public"."user_images" to "anon";

grant trigger on table "public"."user_images" to "anon";

grant truncate on table "public"."user_images" to "anon";

grant update on table "public"."user_images" to "anon";

grant delete on table "public"."user_images" to "authenticated";

grant insert on table "public"."user_images" to "authenticated";

grant references on table "public"."user_images" to "authenticated";

grant select on table "public"."user_images" to "authenticated";

grant trigger on table "public"."user_images" to "authenticated";

grant truncate on table "public"."user_images" to "authenticated";

grant update on table "public"."user_images" to "authenticated";

grant delete on table "public"."user_images" to "service_role";

grant insert on table "public"."user_images" to "service_role";

grant references on table "public"."user_images" to "service_role";

grant select on table "public"."user_images" to "service_role";

grant trigger on table "public"."user_images" to "service_role";

grant truncate on table "public"."user_images" to "service_role";

grant update on table "public"."user_images" to "service_role";

grant delete on table "public"."user_learning_paths" to "anon";

grant insert on table "public"."user_learning_paths" to "anon";

grant references on table "public"."user_learning_paths" to "anon";

grant select on table "public"."user_learning_paths" to "anon";

grant trigger on table "public"."user_learning_paths" to "anon";

grant truncate on table "public"."user_learning_paths" to "anon";

grant update on table "public"."user_learning_paths" to "anon";

grant delete on table "public"."user_learning_paths" to "authenticated";

grant insert on table "public"."user_learning_paths" to "authenticated";

grant references on table "public"."user_learning_paths" to "authenticated";

grant select on table "public"."user_learning_paths" to "authenticated";

grant trigger on table "public"."user_learning_paths" to "authenticated";

grant truncate on table "public"."user_learning_paths" to "authenticated";

grant update on table "public"."user_learning_paths" to "authenticated";

grant delete on table "public"."user_learning_paths" to "service_role";

grant insert on table "public"."user_learning_paths" to "service_role";

grant references on table "public"."user_learning_paths" to "service_role";

grant select on table "public"."user_learning_paths" to "service_role";

grant trigger on table "public"."user_learning_paths" to "service_role";

grant truncate on table "public"."user_learning_paths" to "service_role";

grant update on table "public"."user_learning_paths" to "service_role";

grant delete on table "public"."user_resource" to "anon";

grant insert on table "public"."user_resource" to "anon";

grant references on table "public"."user_resource" to "anon";

grant select on table "public"."user_resource" to "anon";

grant trigger on table "public"."user_resource" to "anon";

grant truncate on table "public"."user_resource" to "anon";

grant update on table "public"."user_resource" to "anon";

grant delete on table "public"."user_resource" to "authenticated";

grant insert on table "public"."user_resource" to "authenticated";

grant references on table "public"."user_resource" to "authenticated";

grant select on table "public"."user_resource" to "authenticated";

grant trigger on table "public"."user_resource" to "authenticated";

grant truncate on table "public"."user_resource" to "authenticated";

grant update on table "public"."user_resource" to "authenticated";

grant delete on table "public"."user_resource" to "service_role";

grant insert on table "public"."user_resource" to "service_role";

grant references on table "public"."user_resource" to "service_role";

grant select on table "public"."user_resource" to "service_role";

grant trigger on table "public"."user_resource" to "service_role";

grant truncate on table "public"."user_resource" to "service_role";

grant update on table "public"."user_resource" to "service_role";

grant delete on table "public"."user_roles" to "anon";

grant insert on table "public"."user_roles" to "anon";

grant references on table "public"."user_roles" to "anon";

grant select on table "public"."user_roles" to "anon";

grant trigger on table "public"."user_roles" to "anon";

grant truncate on table "public"."user_roles" to "anon";

grant update on table "public"."user_roles" to "anon";

grant delete on table "public"."user_roles" to "authenticated";

grant insert on table "public"."user_roles" to "authenticated";

grant references on table "public"."user_roles" to "authenticated";

grant select on table "public"."user_roles" to "authenticated";

grant trigger on table "public"."user_roles" to "authenticated";

grant truncate on table "public"."user_roles" to "authenticated";

grant update on table "public"."user_roles" to "authenticated";

grant delete on table "public"."user_roles" to "service_role";

grant insert on table "public"."user_roles" to "service_role";

grant references on table "public"."user_roles" to "service_role";

grant select on table "public"."user_roles" to "service_role";

grant trigger on table "public"."user_roles" to "service_role";

grant truncate on table "public"."user_roles" to "service_role";

grant update on table "public"."user_roles" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";

grant delete on table "public"."videos" to "anon";

grant insert on table "public"."videos" to "anon";

grant references on table "public"."videos" to "anon";

grant select on table "public"."videos" to "anon";

grant trigger on table "public"."videos" to "anon";

grant truncate on table "public"."videos" to "anon";

grant update on table "public"."videos" to "anon";

grant delete on table "public"."videos" to "authenticated";

grant insert on table "public"."videos" to "authenticated";

grant references on table "public"."videos" to "authenticated";

grant select on table "public"."videos" to "authenticated";

grant trigger on table "public"."videos" to "authenticated";

grant truncate on table "public"."videos" to "authenticated";

grant update on table "public"."videos" to "authenticated";

grant delete on table "public"."videos" to "service_role";

grant insert on table "public"."videos" to "service_role";

grant references on table "public"."videos" to "service_role";

grant select on table "public"."videos" to "service_role";

grant trigger on table "public"."videos" to "service_role";

grant truncate on table "public"."videos" to "service_role";

grant update on table "public"."videos" to "service_role";

grant delete on table "public"."webhook_events" to "anon";

grant insert on table "public"."webhook_events" to "anon";

grant references on table "public"."webhook_events" to "anon";

grant select on table "public"."webhook_events" to "anon";

grant trigger on table "public"."webhook_events" to "anon";

grant truncate on table "public"."webhook_events" to "anon";

grant update on table "public"."webhook_events" to "anon";

grant delete on table "public"."webhook_events" to "authenticated";

grant insert on table "public"."webhook_events" to "authenticated";

grant references on table "public"."webhook_events" to "authenticated";

grant select on table "public"."webhook_events" to "authenticated";

grant trigger on table "public"."webhook_events" to "authenticated";

grant truncate on table "public"."webhook_events" to "authenticated";

grant update on table "public"."webhook_events" to "authenticated";

grant delete on table "public"."webhook_events" to "service_role";

grant insert on table "public"."webhook_events" to "service_role";

grant references on table "public"."webhook_events" to "service_role";

grant select on table "public"."webhook_events" to "service_role";

grant trigger on table "public"."webhook_events" to "service_role";

grant truncate on table "public"."webhook_events" to "service_role";

grant update on table "public"."webhook_events" to "service_role";


