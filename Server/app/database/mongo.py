from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()

client = None
db = None

def connect_to_mongo():
    global client, db
    mongo_url = os.getenv("MONGODB_URL")
    if not mongo_url:
        raise ValueError("MONGODB_URL environment variable is not set.")
    client = MongoClient(mongo_url)
    db = client.get_database("lifeOS")  # Make sure this matches your actual DB name
    print("Connected to MongoDB")
