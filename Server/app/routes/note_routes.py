from fastapi import APIRouter
from app.database import mongo
from fastapi import HTTPException
from app.ml_utils import analyze_sentiment

router = APIRouter()

@router.post("/notes")
async def add_note(note: dict):
    try:
        print("Received note:", note)
        
        sentiment, score = analyze_sentiment(note["text"])
        print("Sentiment:", sentiment, "Score:", score)

        note["sentiment"] = sentiment
        note["confidence"] = round(score, 2)
        note["tags"] = []

        result = db.notes.insert_one(note)
        print("Inserted ID:", result.inserted_id)

        return {"message": "Note added successfully", "note": note}
    except Exception as e:
        print("Exception:", e)
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/notes")
def get_notes():
    notes_collection = mongo.db["notes"]  
    notes = list(notes_collection.find({}, {"_id": 0}))
    return notes
