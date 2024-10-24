import logging
from typing import Annotated

from app.config import Settings, get_settings
from fastapi import APIRouter, Depends

router = APIRouter()
logger = logging.getLogger(__name__)


@router.get("/")
def hello(settings: Annotated[Settings, Depends(get_settings)]):
    """Hello world route"""
    logger.debug("Hello world!")
    return {
        "msg": "Hello World!",
        "app_name": settings.app_name,
        "env": settings.env,
    }


@router.get("/healthcheck")
def healthcheck():
    """Health check route"""
    return {"msg": "ok"}
