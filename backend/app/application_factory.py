import logging.config
import pathlib

from app.routers import healthcheck
from fastapi import FastAPI

logging_conf_path = pathlib.Path(__file__).parents[1] / "logging.conf"
logging.config.fileConfig(logging_conf_path, disable_existing_loggers=False)


def create_app():
    """Creates the FastAPI app"""
    app = FastAPI()
    app.include_router(healthcheck.router)
    return app
