from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional

app = FastAPI(
    title="Task API",
    version="1.0",
    description="A simple to-do list CRUD API - FlyRank Internship Assignment"
)

tasks = [
    {"id": 1, "title": "Complete project proposal", "done": False},
    {"id": 2, "title": "Review pull requests", "done": True},
    {"id": 3, "title": "Prepare meeting notes", "done": False},
]
next_id = 4

class TaskCreate(BaseModel):
    title: str

class TaskUpdate(BaseModel):
    title: Optional[str] = None
    done: Optional[bool] = None

@app.get("/", description="API information endpoint")
async def root():
    return {"name": "Task API", "version": "1.0", "endpoints": ["/tasks"]}

@app.get("/health", description="Health check endpoint")
async def health():
    return {"status": "ok"}

@app.get("/tasks/filter", description="Filter tasks by done status or search by title")
async def filter_tasks(done: Optional[bool] = None, search: Optional[str] = None):
    result = tasks
    if done is not None:
        result = [t for t in result if t["done"] == done]
    if search is not None:
        result = [t for t in result if search.lower() in t["title"].lower()]
    return result

@app.get("/tasks", description="List all tasks")
async def list_tasks():
    return tasks

@app.get("/tasks/{task_id}", description="Get a specific task by ID")
async def get_task(task_id: int):
    for task in tasks:
        if task["id"] == task_id:
            return task
    raise HTTPException(status_code=404, detail=f"Task {task_id} not found")

@app.post("/tasks", status_code=201, description="Create a new task")
async def create_task(task: TaskCreate):
    global next_id
    if not task.title or task.title.strip() == "":
        raise HTTPException(status_code=400, detail="Task title cannot be empty")
    new_task = {"id": next_id, "title": task.title, "done": False}
    next_id += 1
    tasks.append(new_task)
    return new_task

@app.put("/tasks/{task_id}", description="Update an existing task")
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

@app.delete("/tasks/{task_id}", status_code=204, description="Delete a task")
async def delete_task(task_id: int):
    for i, task in enumerate(tasks):
        if task["id"] == task_id:
            tasks.pop(i)
            return None
    raise HTTPException(status_code=404, detail=f"Task {task_id} not found")

@app.get("/stats", description="Get task statistics")
async def get_stats():
    return {
        "total": len(tasks),
        "done": sum(1 for t in tasks if t["done"]),
        "open": sum(1 for t in tasks if not t["done"])
    }

@app.post("/reset", status_code=201, description="Reset tasks to default example tasks")
async def reset_tasks():
    global tasks, next_id
    tasks = [
        {"id": 1, "title": "Complete project proposal", "done": False},
        {"id": 2, "title": "Review pull requests", "done": True},
        {"id": 3, "title": "Prepare meeting notes", "done": False},
    ]
    next_id = 4
    return {"message": "Tasks reset to defaults"}