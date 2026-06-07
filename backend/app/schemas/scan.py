import os
import uuid
from datetime import datetime

from pydantic import BaseModel, computed_field

from app.core.config import settings


class ScanCreate(BaseModel):
    classification: str
    confidence: float


class ScanResponse(BaseModel):
    id: uuid.UUID
    image_path: str
    classification: str
    confidence: float
    created_at: datetime

    model_config = {"from_attributes": True}

    @computed_field  # type: ignore[misc]
    @property
    def image_url(self) -> str:
        base_url = os.environ.get("BASE_URL", settings.base_url or "")
        # Strip any local directory prefix, keep just the filename
        filename = self.image_path.split("/")[-1]
        if base_url:
            return f"{base_url.rstrip('/')}/uploads/{filename}"
        return f"/uploads/{filename}"
