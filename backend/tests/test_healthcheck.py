from fastapi.testclient import TestClient


def test_healthcheck(test_app: TestClient):
    """Tests of the healthcheck"""
    response = test_app.get("/healthcheck")
    assert response.status_code == 200
    assert response.json() == {"msg": "ok"}


def test_hello(test_app: TestClient):
    """Tests of the hello route to ensure settings override works"""
    response = test_app.get("/")
    assert response.status_code == 200
    assert response.json() == {
        "msg": "Hello World!",
        "app_name": "fastapi_starter",
        "env": "testing",
    }
