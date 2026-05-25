from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "DermaScan API"
    debug: bool = True
    database_url: str
    allowed_origins: list[str] = ["*"]

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
