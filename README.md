# Fastapi starter

Fastapi starter generated with Gabriel2409/cookiecutter-fastapi-starter
TODO: Add postgres dependency + test containers
https://samanta-reinosoa.medium.com/testing-fastapi-with-testcontainers-in-gitlab-b7c62068aeef

## Install the prerequisites

- python 3.10 or above, for ex with pyenv: https://github.com/pyenv/pyenv

## Get all dependencies

- Run `make install` to create environments and install dependencies
- Don't forget to activate python environment afterwards: `source venv/bin/activate`

Note: look at the `Makefile` to see the details of the installation

## Post installation checks

- Installation should have created a `.env` file in the `backend` folder.
- Note that there is no sensitive information in this application so you won't need to modify it

## Running the application

- The simplest way is to use vscode task: `Run Fastapi`
  You can check the details of the commands in `.vscode/tasks.json`
- Alternatively,

  - in `backend` folder, run `uvicorn app.main:app --reload`

- Check that app is running by going to `http://localhost:8000/docs`
