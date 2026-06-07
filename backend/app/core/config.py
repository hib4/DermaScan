from pydantic_settings import BaseSettings
from pydantic import model_validator, Field


class Settings(BaseSettings):
    app_name: str = "DermaScan API"
    debug: bool = True
    pg_host: str = Field(default="localhost", validation_alias="PGHOST")
    pg_database: str = Field(default="dermascan", validation_alias="PGDATABASE")
    pg_user: str = Field(default="user", validation_alias="PGUSER")
    pg_password: str = Field(default="password", validation_alias="PGPASSWORD")
    pg_sslmode: str = Field(default="disable", validation_alias="PGSSLMODE")
    pg_channel_binding: str = Field(default="disable", validation_alias="PGCHANNELBINDING")
    allowed_origins: list[str] = ["*"]
    secret_key: str = "change-me-in-production-use-a-random-string"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    base_url: str = Field(default="", validation_alias="BASE_URL")

    database_url: str = ""

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8", "extra": "ignore"}

    @model_validator(mode="before")
    @classmethod
    def build_database_url(cls, values):
        if isinstance(values, dict):
            pg_host = values.get("pg_host", values.get("PGHOST", "localhost"))
            pg_database = values.get("pg_database", values.get("PGDATABASE", "dermascan"))
            pg_user = values.get("pg_user", values.get("PGUSER", "user"))
            pg_password = values.get("pg_password", values.get("PGPASSWORD", "password"))
            values["database_url"] = f"postgresql+asyncpg://{pg_user}:{pg_password}@{pg_host}:5432/{pg_database}"
        return values


settings = Settings()
