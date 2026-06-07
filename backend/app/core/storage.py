import os
import uuid
from pathlib import Path

import aiofiles

# Use /tmp on serverless (Vercel), local directory otherwise
UPLOAD_DIR = Path("/tmp/uploads") if os.environ.get("VERCEL") else Path("uploads")
UPLOAD_DIR.mkdir(exist_ok=True)

ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp", ".heic"}


def generate_filename(original_filename: str) -> str:
    ext = Path(original_filename).suffix.lower()
    if ext not in ALLOWED_EXTENSIONS:
        ext = ".jpg"
    return f"{uuid.uuid4().hex}{ext}"


async def save_upload(file_bytes: bytes, filename: str) -> str:
    dest = UPLOAD_DIR / filename
    async with aiofiles.open(dest, "wb") as f:
        await f.write(file_bytes)
    return str(dest)
