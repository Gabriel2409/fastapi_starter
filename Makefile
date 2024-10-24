# where to install python venv: requirement files are in this directory
PROJECT_DIR=.

# fastapi app dir
BACKEND_DIR=./backend

.PHONY: help git check-prerequisites create-env-file venv install

# Display help message
help:
	@echo "Available targets:"
	@echo "  - help: Display this help message."
	@echo "  - git: Initialize git repository if repo is not a git repository"
	@echo "  - check-prerequisites: checks that important libraries are installed"
	@echo "  - create-env-file: creates .env file from .env.example files"
	@echo "  - venv: Create the python virtual environment and install dependencies"
	@echo "  - install: checks that necessary tools are installed then launches venv target"
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
	@command -v python >/dev/null 2>&1 || { echo >&2 "Python is not installed. Aborting."; exit 1; }

# I like to have an .env.example file which shows what structure the .env file must have
# The idea is to copy the .env.example file to .env if it doesn't exist then modify
# the env fields with sensitive information if needed
create-env-file:
	@test -e ${BACKEND_DIR}/.env || (echo "Creating ${BACKEND_DIR}/.env file, please update the fields" && cp ${BACKEND_DIR}/.env.example ${BACKEND_DIR}/.env )

# inspired by https://stackoverflow.com/questions/24736146/how-to-use-virtualenv-in-makefile
# venv is a phony target: to know if we must update it we look at the touchfile, which is
# defined below
venv: ${PROJECT_DIR}/venv/touchfile

# checks for requirements and requirements-dev files, launches script if they were modified
# then we touch the venv/touchfile so that its timestamp is more recent than the requirements files
# This ensures that, when we launch the venv target, it will only run if one of the requirements files
# was modified or if the venv/touchfile doesn't exist (for example if we just cloned the repo)
${PROJECT_DIR}/venv/touchfile: ${PROJECT_DIR}/requirements.txt ${PROJECT_DIR}/requirements-dev.txt
	@echo "Setting up python virtual environment..."
	cd ${PROJECT_DIR} && \
		test -d venv || python -m venv venv
		. venv/bin/activate && \
		pip install --upgrade pip && \
		pip install -r ${PROJECT_DIR}/requirements.txt && \
		pip install -r ${PROJECT_DIR}/requirements-dev.txt && \
		pre-commit install && \
		pre-commit autoupdate
	touch ${PROJECT_DIR}/venv/touchfile



# make install will just run all the targets
install: git check-prerequisites create-env-file venv
	@echo "Installation complete. Don't forget to activate environment"

pytest-cov:
	. venv/bin/activate && pytest -vv --cov=. --cov-report=html --cov-report=term

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
	rm -rf ${PROJECT_DIR}/venv



# if you have docker installed.

# launches app in watch mode for development
docker-watch:
	docker compose watch

# runs the tests in the docker container
docker-pytest-cov:
	docker compose run --rm backend pytest -vv --cov=. --cov-report=html --cov-report=term
