import json
from typing import Any

from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session

from app.core.deps import get_db_dep
from app.models.webhook_event import WebhookEvent

router = APIRouter(prefix="/webhooks", tags=["Webhooks"])


def _safe_json_loads(raw: bytes) -> Any:
    try:
        return json.loads(raw.decode("utf-8"))
    except Exception:
        return None


@router.post("/fastspring", status_code=202)
async def fastspring_webhook(request: Request, db: Session = Depends(get_db_dep)):
    body = await request.body()
    payload = _safe_json_loads(body)

    event_id = None
    event_type = None
    if isinstance(payload, dict):
        if payload.get("id") is not None:
            event_id = str(payload.get("id"))
        if payload.get("type") is not None:
            event_type = str(payload.get("type"))

    evt = WebhookEvent(provider="fastspring", event_id=event_id, event_type=event_type)
    evt.payload_json = body.decode("utf-8", errors="replace") if body else "{}"
    evt.headers_json = json.dumps(dict(request.headers), ensure_ascii=False)

    db.add(evt)
    db.commit()

    return {"status": "accepted"}
