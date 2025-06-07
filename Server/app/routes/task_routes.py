from fastapi import APIRouter
from app.models.task_model import Task
from app.database import mongo
from bson import ObjectId
from fastapi import Body
from pydantic import BaseModel


router = APIRouter()

class TaskUpdate(BaseModel):
    is_completed: bool

@router.get("/tasks")
def get_tasks():
    try:
        tasks = list(mongo.db.tasks.find())
        for task in tasks:
             task["id"] = str(task["_id"]) 
             del task["_id"]
        return tasks
    except Exception as e:
        return {"error": str(e)}



@router.post("/tasks")
def create_task(task: Task):
    result = mongo.db.tasks.insert_one(task.dict())
    return {"id": str(result.inserted_id)}

    

@router.patch("/tasks/{task_id}")
def update_task_status(task_id: str, update: TaskUpdate):
    try:
        print(f"Received update: {task_id} => is_completed = {update.is_completed}")

        result = mongo.db.tasks.update_one(
            {"_id": ObjectId(task_id)},
            {"$set": {"is_completed": bool(update.is_completed)}}
        )
        if result.modified_count == 1:
            return {"message": "Task updated"}
        return {"message": "No changes made"}
    except Exception as e:
        return {"error": str(e)}


@router.put("/tasks/{task_id}")
def update_task(task_id: str, task: Task):
    try:
        result = mongo.db.tasks.update_one(
            {"_id": ObjectId(task_id)},
            {"$set": task.dict()}
        )
        if result.modified_count == 1:
            return {"message": "Task updated"}
        else:
            return {"message": "No changes made"}
    except Exception as e:
        return {"error": str(e)}



@router.delete("/tasks/{task_id}")
def delete_task(task_id: str):
    result = mongo.db.tasks.delete_one({"_id": ObjectId(task_id)})
    if result.deleted_count == 1:
        return {"message": "Task deleted"}
    raise HTTPException(status_code=404, detail="Task not found")
