from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user
from app.crud.crud_scan import create_scan, get_user_scans
from app.core.storage import encode_to_base64, guess_mime_type
from app.db.session import get_db
from app.models.user import User
from app.schemas.scan import ScanResponse

router = APIRouter(prefix="/api/scans", tags=["scans"])


@router.post("", response_model=ScanResponse, status_code=status.HTTP_201_CREATED)
async def upload_scan(
    image: UploadFile = File(...),
    classification: str = Form(...),
    confidence: float = Form(...),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    if not image.content_type or not image.content_type.startswith("image/"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="File must be an image",
        )
    file_bytes = await image.read()
    image_data = encode_to_base64(file_bytes)
    mime_type = guess_mime_type(image.filename or "")
    scan = await create_scan(
        db=db,
        user=user,
        image_data=image_data,
        image_path=mime_type,  # store mime type for data URI construction
        classification=classification,
        confidence=confidence,
    )
    return scan


@router.get("", response_model=list[ScanResponse])
async def list_scans(
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    return await get_user_scans(db=db, user_id=user.id)
