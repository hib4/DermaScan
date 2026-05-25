from app.api.routers.auth import router as auth_router
from app.api.routers.scans import router as scans_router

__all__ = ["auth_router", "scans_router"]
