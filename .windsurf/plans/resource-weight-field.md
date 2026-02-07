# Add per-user weights + engagement tracking + community metrics

This plan adds per-user weight + engagement tracking columns on `user_resource` and community metrics columns on `resources`, then wires create/attach/open flows to keep them updated.

## 1) Confirm current state (no code changes)

- Verify backend `UserResource` + `Resource` models do not already define the requested columns.
- Verify Alembic migrations do not already add any of these columns.
- Verify frontend `AddResource.vue` already collects `selectedWeight` but does not send it in `createMyResourceFromUrl`.

## 2) Decide data ownership + shape (clarify before implementing)

- Per-user weights live on `user_resource`:
  - `manual_weight: int` (user set)
  - `behavior_weight: int` (system computed)
  - `effective_weight: int` (final)
- Engagement tracking on `user_resource`:
  - `added_at: datetime`
  - `last_opened: datetime`
  - `open_count: int`
  - `completion_status: bool`
- Community metrics live on `resources`:
  - `community_score: int`
  - `save_count: int`
  - `trending_score: int`

### Design rationale (recommended)

- **Personal importance is per-user**
  - Put *user intent* in `user_resource.manual_weight`.
  - Reason: the same resource can be “high priority” for you but “low priority” for others.

- **Public area should not force a user’s personal weight onto everyone**
  - Public `/resources` should surface only **community aggregates** (`community_score`, `save_count`, `trending_score`).
  - When a user adds a public resource into My Resources, you can **prefill a suggested weight** from community signals, but store the final personal weight on `user_resource`.

- **How to connect public signals to personal weight**
  - `resources.community_score` can be an aggregate derived from user weights, e.g.
    - weighted average of `effective_weight` (only where users set manual or have enough behavior)
    - or a simpler sum/average of `manual_weight`
  - This avoids a paradox where public items come with a “fixed” weight that the user must undo.

- **Effective weight formula**
  - Simple and robust:
    - `effective_weight = manual_weight` if user set it
    - else `effective_weight = behavior_weight` (system computed)

- **Recommendation for integer scale**
  - Map the UI tiers to ints (example):
    - `soil=1`, `iron=2`, `bronze=3`, `silver=4`, `gold=5`
  - Keep `manual_weight` nullable to distinguish “unset” vs “set to 0/1”.

Open questions (need your confirmation):
- Should `completion_status` be a simple boolean (`true`=completed) or should we use a richer status later (e.g. `not_started/in_progress/completed`)?
- For new attaches, should `added_at` replace `created_at` (or keep both; default `added_at = created_at`)?

Additional design question:
- When attaching an already-saved resource again, should we:
  - keep existing `manual_weight`
  - or overwrite it with the incoming `manual_weight`?

Confirmed policy choices

- Default manual weight: if user does not set a weight explicitly, set `manual_weight = 1`.
- Re-attach behavior: if the resource is already saved and the request includes `manual_weight`, overwrite the existing `manual_weight`.

Confirmed implementation decisions

- `completion_status` stays boolean.
- Add `added_at` and backfill historical rows from `created_at` in the migration.

## 3) Backend changes (FastAPI + SQLAlchemy)

- Add columns to `backend/app/models/user_resource.py`:
  - `manual_weight`: `Integer`, nullable
  - `behavior_weight`: `Integer`, nullable
  - `effective_weight`: `Integer`, nullable
  - `added_at`: `DateTime`, default `datetime.now`
  - `last_opened`: `DateTime`, nullable
  - `open_count`: `Integer`, default `0`
  - `completion_status`: `Boolean`, default `False`
- Add columns to `backend/app/models/resource.py`:
  - `community_score`: `Integer`, default `0`
  - `save_count`: `Integer`, default `0`
  - `trending_score`: `Integer`, default `0`
- Add Alembic migration under `backend/alembic/versions/`.
  - `upgrade`:
    - add above columns to `user_resource`
    - add above columns to `resources`
  - `downgrade`: drop them
- Update Pydantic schemas:
  - `backend/app/schemas/resources/resource.py`
    - Add optional `manual_weight` to `ResourceCreateFromUrl` request (so frontend can send it)
    - Add fields to `ResourceResponse`/`ResourceDetailResponse`:
      - `manual_weight`, `behavior_weight`, `effective_weight`
      - `added_at`, `last_opened`, `open_count`, `completion_status`
      - `community_score`, `save_count`, `trending_score`
- Update CRUD:
  - `backend/app/curd/resources/resource_curd.py::create_from_url`
    - Accept `manual_weight` (optional)
    - Persist it when creating the `UserResource` row
    - Initialize `added_at`, `open_count`, and optionally recompute `effective_weight`
  - `backend/app/curd/resources/resource_curd.py::attach_to_user`
    - When attaching:
      - set `added_at` when creating
      - update `save_count` on the linked `Resource` (increment)
      - if already exists, decide whether to overwrite weights per your rule
- Update routers:
  - `backend/app/routers/resources/resource.py`
    - When listing/returning “my resources”, include per-user fields from the joined `UserResource` row.
    - For public `/resources` list, include only community metrics (not per-user fields).

Event updates (backend):
- When user opens a resource detail (e.g. `GET /resources/me/{resource_id}`):
  - update `last_opened = now`, `open_count += 1`
- When user marks complete (new endpoint or extend update):
  - set `completion_status`

## 4) Frontend changes (Vue)

- Update API client:
  - `frontend/app/src/api/resource.ts`
    - Extend `createMyResourceFromUrl(url, payload)` payload to include `manual_weight?: number`.
    - Extend `DbResource` / `DbResourceDetail` typing with:
      - per-user fields (for “my resources” responses)
      - community fields (for public and my resources)
- Update Add Resource page:
  - `frontend/app/src/pages/AddResource.vue`
    - Map existing `selectedWeight` UI to `manual_weight` (int) and send it.

Optional later UI:
- Show open count / last opened
- Allow toggling completion status

## 5) Acceptance checks

- Add resource with a manual weight → DB row has `user_resource.manual_weight` set.
- Attach/save resource increments `resources.save_count`.
- Opening `GET /resources/me/{id}` increments `user_resource.open_count` and sets `last_opened`.
- My resources list/detail APIs include per-user fields.
- Public resources list APIs include community fields.


