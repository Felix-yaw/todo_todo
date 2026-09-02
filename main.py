# Stage 5 & 6: Complete Task API with Swagger UI, Extras & README
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional

app = FastAPI(title="Task API", version="1.0", description="A simple to-do list CRUD API")

# In-memory task store
tasks = [
    {"id": 1, "title": "Complete project proposal", "done": False},
    {"id": 2, "title": "Review pull requests", "done": True},
    {"id": 3, "title": "Prepare meeting notes", "done": False},
]
next_id = 4

# Pydantic models for validation
class TaskCreate(BaseModel):
    title: str

class TaskUpdate(BaseModel):
    title: Optional[str] = None
    done: Optional[bool] = None

# Root & Health
@app.get("/")
async def root():
    return {"name": "Task API", "version": "1.0", "endpoints": ["/tasks"]}

@app.get("/health")
async def health():
    return {"status": "ok"}

# Filter must come before parameterized routes
@app.get("/tasks/filter")
async def filter_tasks(done: Optional[bool] = None, search: Optional[str] = None):
    result = tasks
    if done is not None:
        result = [t for t in result if t["done"] == done]
    if search is not None:
        result = [t for t in result if search.lower() in t["title"].lower()]
    return result

# Read - list all tasks
@app.get("/tasks")
async def list_tasks():
    return tasks

# Read - single task
@app.get("/tasks/{task_id}")
async def get_task(task_id: int):
    for task in tasks:
        if task["id"] == task_id:
            return task
    raise HTTPException(status_code=404, detail=f"Task {task_id} not found")

# Create
@app.post("/tasks", status_code=201)
async def create_task(task: TaskCreate):
    global next_id
    if not task.title or task.title.strip() == "":
        raise HTTPException(status_code=400, detail="Task title cannot be empty")
    new_task = {"id": next_id, "title": task.title, "done": False}
    next_id += 1
    tasks.append(new_task)
    return new_task

# Update
@app.put("/tasks/{task_id}")
async def update_task(task_id: int, task_update: TaskUpdate):
    for i, task in enumerate(tasks):
        if task["id"] == task_id:
            if task_update.title is not None:
                if task_update.title.strip() == "":
                    raise HTTPException(status_code=400, detail="Task title cannot be empty")
                tasks[i]["title"] = task_update.title
            if task_update.done is not None:
                tasks[i]["done"] = task_update.done
            return tasks[i]
    raise HTTPException(status_code=404, detail=f"Task {task_id} not found")

# Delete
@app.delete("/tasks/{task_id}", status_code=204)
async def delete_task(task_id: int):
    for i, task in enumerate(tasks):
        if task["id"] == task_id:
            tasks.pop(i)
            return None
    raise HTTPException(status_code=404, detail=f"Task {task_id} not found")

# Extra: Stats endpoint
@app.get("/stats")
async def get_stats():
    return {
        "total": len(tasks),
        "done": sum(1 for t in tasks if t["done"]),
        "open": sum(1 for t in tasks if not t["done"])
    }

# Extra: Reset endpoint
@app.post("/reset", status_code=201)
async def reset_tasks():
    global tasks, next_id
    tasks = [
        {"id": 1, "title": "Complete project proposal", "done": False},
        {"id": 2, "title": "Review pull requests", "done": True},
        {"id": 3, "title": "Prepare meeting notes", "done": False},
    ]
    next_id = 4
    return {"message": "Tasks reset to defaults"}