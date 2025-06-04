from fastapi import FastAPI
from app.database.mongo import connect_to_mongo
from app.routes import task_routes

app = FastAPI()

@app.on_event("startup")
def startup_db():
    connect_to_mongo()

@app.get("/")
def read_root():
    return {"message": "FastAPI is working"}

app.include_router(task_routes.router)
