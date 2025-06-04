from fastapi import APIRouter
from app.models.task_model import Task
from app.database import mongo
from bson import ObjectId

router = APIRouter()

@router.get("/tasks")
def get_tasks():
    try:
        tasks = list(mongo.db.tasks.find())
        for task in tasks:
            task["_id"] = str(task["_id"])
        return tasks
    except Exception as e:
        return {"error": str(e)}



@router.post("/tasks")
def create_task(task: Task):
    result = db.tasks.insert_one(task.dict())
    return {"id": str(result.inserted_id)}

@router.put("/tasks/{task_id}")
def update_task(task_id: str, task: Task):
    db.tasks.update_one({"_id": ObjectId(task_id)}, {"$set": task.dict()})
    return {"message": "Task updated"}

@router.delete("/tasks/{task_id}")
def delete_task(task_id: str):
    db.tasks.delete_one({"_id": ObjectId(task_id)})
    return {"message": "Task deleted"}
