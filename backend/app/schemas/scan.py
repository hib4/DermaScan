import uuid
from datetime import datetime

from pydantic import BaseModel


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
