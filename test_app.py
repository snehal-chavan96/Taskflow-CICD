
import pytest
from app import app, tasks


@pytest.fixture
def client():
    app.config["TESTING"] = True

    with app.test_client() as client:
        yield client


@pytest.fixture(autouse=True)
def reset_tasks():
    tasks.clear()
    tasks.extend([
        {"id": 1, "title": "Learn Jenkins", "completed": False},
        {"id": 2, "title": "Learn Terraform", "completed": False}
    ])


def test_homepage(client):
    response = client.get("/")

    assert response.status_code == 200
    assert b"TaskFlow" in response.data


def test_add_task(client):
    response = client.post(
        "/add",
        data={"title": "Learn Python"},
        follow_redirects=True
    )

    assert response.status_code == 200
    assert any(task["title"] == "Learn Python" for task in tasks)


def test_add_empty_task(client):
    response = client.post(
        "/add",
        data={"title": "   "},
        follow_redirects=True
    )

    assert response.status_code == 200
    assert len(tasks) == 2


def test_complete_task(client):
    response = client.get("/complete/1", follow_redirects=True)

    assert response.status_code == 200
    assert tasks[0]["completed"] is True


def test_delete_task(client):
    response = client.get("/delete/1", follow_redirects=True)

    assert response.status_code == 200
    assert len(tasks) == 1
    assert tasks[0]["id"] == 2
