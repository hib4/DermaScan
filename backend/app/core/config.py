from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "DermaScan API"
    debug: bool = True
    database_url: str
    allowed_origins: list[str] = ["*"]
    secret_key: str = "change-me-in-production-use-a-random-string"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
