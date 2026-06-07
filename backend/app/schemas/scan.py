import uuid
from datetime import datetime

from pydantic import BaseModel, computed_field


class ScanCreate(BaseModel):
    classification: str
    confidence: float


class ScanResponse(BaseModel):
    id: uuid.UUID
    image_path: str | None = None
    image_data: str
    classification: str
    confidence: float
    created_at: datetime

    model_config = {"from_attributes": True}

    @computed_field  # type: ignore[misc]
    @property
    def image_uri(self) -> str:
        """Return a data URI from stored base64 image data."""
        mime = self.image_path or "image/jpeg"
        # Ensure mime starts with "image/"
        if not mime.startswith("image/"):
            mime = f"image/{mime}"
        return f"data:{mime};base64,{self.image_data}"
