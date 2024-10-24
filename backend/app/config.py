import os
import pathlib
from functools import lru_cache

from dotenv import load_dotenv
from pydantic_settings import BaseSettings

# pydantic allows to load the env file directly with SettingsConfigDict
# but I actually prefer to load the variables with dotenv  and use os.getenv to set them
# That way, it does not matter if the variables are loaded from the
# env file (local dev) or if the variables are set differently (in production)
basedir = pathlib.Path(__file__).parents[1]
load_dotenv(basedir / ".env")


class Settings(BaseSettings):
    """Main settings"""

    app_name: str = "fastapi_starter"
    env: str = os.getenv("ENV", "development")

    # alternate way to load env variables.
    # model_config = SettingsConfigDict(env_file=".env")


@lru_cache
def get_settings() -> Settings:
    """Retrieves the fastapi settings"""
    return Settings()
