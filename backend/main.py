import os
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles

from app.api.routers.auth import router as auth_router
from app.api.routers.scans import router as scans_router
from app.core.config import settings
from app.db.session import check_connection

app = FastAPI(title=settings.app_name, debug=settings.debug)

# When using wildcard origins, credentials must be False (CORS spec restriction)
is_wildcard = settings.allowed_origins == ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=not is_wildcard,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)
app.include_router(scans_router)

# Serve uploaded images at /uploads/<filename>
# Use /tmp on serverless (Vercel), local directory otherwise
uploads_dir = Path("/tmp/uploads") if os.environ.get("VERCEL") else Path("uploads")
uploads_dir.mkdir(exist_ok=True)
app.mount("/uploads", StaticFiles(directory=str(uploads_dir)), name="uploads")


@app.get("/")
@app.get("/api/health")
async def health():
    if await check_connection():
        return {"status": "healthy", "database": "connected"}
    return JSONResponse(
        status_code=503,
        content={"status": "degraded", "database": "error"},
    )
