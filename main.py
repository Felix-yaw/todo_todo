"""
Task API - Backend for Flutter todo_todo app
"""
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(title="Task API", version="1.0")

# ─── Data Store ─────────────────────────────────────────────
tasks: dict = {}
subtasks: dict = {}  # taskId -> [subtask dicts]

# ─── Pydantic Models ────────────────────────────────────────
class TaskCreate(BaseModel):
    name: str

class TaskUpdate(BaseModel):
    name: str

class SubtaskUpdate(BaseModel):
    name: Optional[str] = None
    is_done: Optional[bool] = None

# ─── Tasks ──────────────────────────────────────────────────

@app.get("/tasks")
async def get_tasks():
    result = []
    for task_id, task in tasks.items():
        task_subtasks = subtasks.get(task_id, [])
        result.append({
            "id": task_id,
            "name": task["name"],
            "subtasks": task_subtasks,
        })
    return result

@app.post("/tasks", status_code=201)
async def create_task(task_in: TaskCreate):
    if not task_in.name or task_in.name.strip() == "":
        raise HTTPException(status_code=400, detail="Task name cannot be empty")
    task_id = str(len(tasks) + 1)
    tasks[task_id] = {"id": task_id, "name": task_in.name.strip()}
    subtasks[task_id] = []
    return {"id": task_id, "name": task_in.name.strip(), "subtasks": []}

@app.put("/tasks/{task_id}")
async def update_task(task_id: str, task_update: TaskUpdate):
    if task_id not in tasks:
        raise HTTPException(status_code=404, detail="Task not found")
    if not task_update.name or task_update.name.strip() == "":
        raise HTTPException(status_code=400, detail="Task name cannot be empty")
    tasks[task_id]["name"] = task_update.name.strip()
    return {"id": task_id, "name": tasks[task_id]["name"]}

@app.delete("/tasks/{task_id}", status_code=204)
async def delete_task(task_id: str):
    if task_id not in tasks:
        raise HTTPException(status_code=404, detail="Task not found")
    del tasks[task_id]
    if task_id in subtasks:
        del subtasks[task_id]
    return None

# ─── Subtasks ───────────────────────────────────────────────

@app.post("/tasks/{task_id}/subtasks", status_code=201)
async def create_subtask(task_id: str, subtask_in: TaskCreate):
    if task_id not in tasks:
        raise HTTPException(status_code=404, detail="Task not found")
    if not subtask_in.name or subtask_in.name.strip() == "":
        raise HTTPException(status_code=400, detail="Subtask name cannot be empty")
    subtask_id = str(len(subtasks.get(task_id, [])) + 1)
    subtask = {
        "id": subtask_id,
        "task_id": task_id,
        "name": subtask_in.name.strip(),
        "is_done": False,
    }
    subtasks[task_id].append(subtask)
    return subtask

@app.put("/subtasks/{subtask_id}")
async def update_subtask(subtask_id: str, subtask_update: SubtaskUpdate):
    for task_id, st_list in subtasks.items():
        for st in st_list:
            if st["id"] == subtask_id:
                if subtask_update.name is not None:
                    st["name"] = subtask_update.name
                if subtask_update.is_done is not None:
                    st["is_done"] = subtask_update.is_done
                return st
    raise HTTPException(status_code=404, detail="Subtask not found")

@app.delete("/subtasks/{subtask_id}", status_code=204)
async def delete_subtask(subtask_id: str):
    for task_id, st_list in subtasks.items():
        for i, st in enumerate(st_list):
            if st["id"] == subtask_id:
                st_list.pop(i)
                return None
    raise HTTPException(status_code=404, detail="Subtask not found")