import base64


def encode_to_base64(file_bytes: bytes) -> str:
    """Encode image bytes to base64 string for database storage."""
    return base64.b64encode(file_bytes).decode("utf-8")


def guess_mime_type(filename: str) -> str:
    """Guess MIME type from filename extension."""
    ext = filename.rsplit(".", 1)[-1].lower() if "." in filename else ""
    mime_map = {"jpg": "jpeg", "jpeg": "jpeg", "png": "png", "webp": "webp", "gif": "gif", "bmp": "bmp", "heic": "heic", "heif": "heic"}
    return f"image/{mime_map.get(ext, 'jpeg')}"
