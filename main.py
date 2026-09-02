from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Task API", version="1.0")

tasks = [
    {"id": 1, "title": "Complete project proposal", "done": False},
    {"id": 2, "title": "Review pull requests", "done": True},
    {"id": 3, "title": "Prepare meeting notes", "done": False},
]
next_id = 4

class TaskCreate(BaseModel):
    title: str

@app.get("/")
async def root():
    return {"name": "Task API", "version": "1.0", "endpoints": ["/tasks"]}

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/tasks")
async def list_tasks():
    return tasks

@app.get("/tasks/{task_id}")
async def get_task(task_id: int):
    for task in tasks:
        if task["id"] == task_id:
            return task
    raise HTTPException(status_code=404, detail=f"Task {task_id} not found")

@app.post("/tasks", status_code=201)
async def create_task(task: TaskCreate):
    global next_id
    if not task.title or task.title.strip() == "":
        raise HTTPException(status_code=400, detail="Task title cannot be empty")
    new_task = {"id": next_id, "title": task.title, "done": False}
    next_id += 1
    tasks.append(new_task)
    return new_task