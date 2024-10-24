# where to install python venv: requirement files are in this directory
PROJECT_DIR=.

# fastapi app dir
BACKEND_DIR=./backend

.PHONY: help git check-prerequisites create-env-file venv install generate-requirements-txt

# Display help message
help:
	@echo "Available targets:"
	@echo "  - help: Display this help message."
	@echo "  - git: Initialize git repository if repo is not a git repository"
	@echo "  - check-prerequisites: checks that important libraries are installed"
	@echo "  - create-env-file: creates .env file from .env.example files"
	@echo "  - venv: Create the python virtual environment and install dependencies"
	@echo "  - install: checks that necessary tools are installed then launches venv target"
	@echo "  - generate-requirements-txt: generates a requirements.txt file from pyproject.toml"
	@echo "  - pytest-cov: Runs pytest with html coverage"
	@echo "  - clean: Remove generated files or directories."

git:
	@if [ ! -d ${PROJECT_DIR}/.git ]; then \
		echo "Initializing Git repository..."; \
		cd ${PROJECT_DIR} && git init; \
	else \
		echo "Git repository already exists."; \
	fi

# just here to make install fail if we don't have the right tools
# You can add the extra tools you need here
check-prerequisites:
	@command -v uv >/dev/null 2>&1 || { echo >&2 "uv is not installed. Aborting."; exit 1; }

# I like to have an .env.example file which shows what structure the .env file must have
# The idea is to copy the .env.example file to .env if it doesn't exist then modify
# the env fields with sensitive information if needed
create-env-file:
	@test -e ${BACKEND_DIR}/.env || (echo "Creating ${BACKEND_DIR}/.env file, please update the fields" && cp ${BACKEND_DIR}/.env.example ${BACKEND_DIR}/.env )

venv:
	@echo "Setting up python virtual environment..."
	cd ${PROJECT_DIR} && \
		uv sync && \
		uv run -- pre-commit install && \
		uv run -- pre-commit autoupdate

# make install will just run all the targets
install: git check-prerequisites create-env-file venv generate-requirements-txt
	@echo "Installation complete. Don't forget to activate environment"

pytest-cov:
	uv run -- pytest -vvrA --cov=. --cov-report=html --cov-report=term

# deletes the virtual environment
clean:
	@echo "Cleaning up..."
	find . -name '*.pyc' -exec rm -rf {} +
	find . -name '__pycache__' -exec rm -rf {} +
	find . -type d -name '.pytest_cache' -exec rm -rf {} +
	find . -type d -name '*.egg-info' -exec rm -rf {} +
	find . -type d -name 'htmlcov' -exec rm -rf {} +
	find . -name '.coverage' -exec rm -rf {} +
	@echo "Removing python virtual environment..."
	rm -rf ${PROJECT_DIR}/.venv

generate-requirements-txt:
	uv pip compile --generate-hashes pyproject.toml -o requirements.txt >> /dev/null

# if you have docker installed.

# launches app in watch mode for development
docker-watch:
	docker compose watch

# runs the tests in the docker container
docker-pytest-cov:
	docker compose run --rm backend pytest -vv --cov=. --cov-report=html --cov-report=term
