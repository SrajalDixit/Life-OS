from fastapi import FastAPI
from app.database.mongo import connect_to_mongo
from app.routes import task_routes
import os
from dotenv import load_dotenv  
from app.routes import chatbot_route  



load_dotenv() 
API_KEY = os.getenv("OPENROUTER_API_KEY")

app = FastAPI()

@app.on_event("startup")
def startup_db():
    connect_to_mongo()

@app.get("/")
def read_root():
    return {"message": "FastAPI is working"}

app.include_router(task_routes.router)
app.include_router(chatbot_route.router) 
