from fastapi import APIRouter, Depends, Form, HTTPException, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import create_access_token, hash_password, verify_password
from app.db.session import get_db
from app.models.user import User
from app.schemas.token import OAuthPayload, Token
from app.schemas.user import UserCreate, UserResponse

router = APIRouter(prefix="/api/auth", tags=["auth"])


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(payload: UserCreate, db: AsyncSession = Depends(get_db)):
    hashed = hash_password(payload.password)
    user = User(email=payload.email, hashed_password=hashed)
    db.add(user)
    try:
        await db.commit()
    except IntegrityError:
        await db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already registered",
        )
    await db.refresh(user)
    return user


@router.post("/login", response_model=Token)
async def login(
    email: str = Form(...),
    password: str = Form(...),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(User).where(User.email == email))
    user = result.scalar_one_or_none()
    if user is None or not verify_password(password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials",
        )
    token = create_access_token(user.id)
    return Token(access_token=token, token_type="bearer")


@router.post("/oauth", response_model=Token)
async def oauth(payload: OAuthPayload):
    """
    Stub: validates an external OAuth provider token (Google/Apple),
    looks up or creates the user, and returns our internal JWT.
    """
    # TODO: implement provider token validation
    # 1. Validate payload.provider_token with Google/Apple
    # 2. Extract email from the provider response
    # 3. Look up or create the user
    # 4. Return Token(access_token=create_access_token(user.id))
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail=f"OAuth provider '{payload.provider}' not yet implemented",
    )
