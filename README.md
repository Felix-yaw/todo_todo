# Task API - CRUD Assignment

A simple REST API for managing tasks (to-do list) built with FastAPI.

## How to Run

```bash
cd todo-api
C:\develop\employee-self-service-portal-todo-api\venv\Scripts\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

## Swagger UI

Visit: http://localhost:8000/docs

## Endpoints

| Method | Endpoint            | Description              |
|--------|---------------------|--------------------------|
| GET    | /                   | API info                 |
| GET    | /health             | Health check             |
| GET    | /tasks              | List all tasks           |
| GET    | /tasks/{id}         | Get a specific task      |
| POST   | /tasks              | Create a new task        |
| PUT    | /tasks/{id}         | Update a task            |
| DELETE | /tasks/{id}         | Delete a task            |
| GET    | /tasks/filter       | Filter/search tasks      |
| GET    | /stats              | Task statistics          |
| POST   | /reset              | Reset tasks to defaults  |

## Example curl Command

```bash
curl http://localhost:8000/tasks
```

Output:
```json
[{"id":1,"title":"Complete project proposal","done":false}, ...]
```