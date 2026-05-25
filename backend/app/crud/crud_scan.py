import uuid

from sqlalchemy import desc, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.scan import Scan
from app.models.user import User


async def create_scan(
    db: AsyncSession,
    user: User,
    image_path: str,
    classification: str,
    confidence: float,
) -> Scan:
    scan = Scan(
        user_id=user.id,
        image_path=image_path,
        classification=classification,
        confidence=confidence,
    )
    db.add(scan)
    await db.commit()
    await db.refresh(scan)
    return scan


async def get_user_scans(db: AsyncSession, user_id: uuid.UUID) -> list[Scan]:
    result = await db.execute(
        select(Scan)
        .where(Scan.user_id == user_id)
        .order_by(desc(Scan.created_at))
    )
    return list(result.scalars().all())
