from fastapi import APIRouter
from app.database import mongo
from fastapi import HTTPException
from app.ml_utils import analyze_sentiment
from bson import ObjectId


router = APIRouter()

def serialize_note(note):
    note['_id'] = str(note['_id'])  # Convert ObjectId to string
    return note


@router.post("/notes")
async def add_note(note: dict):
    try:
        print("Received note:", note)
        text = note.get("text")
        if not text:
            raise HTTPException(status_code=400, detail="Missing 'text' field.")
        
        sentiment, score = analyze_sentiment(text)
        print("Sentiment:", sentiment, "Score:", score)

        note["sentiment"] = sentiment
        note["confidence"] = round(score, 2)
        note["tags"] = ["General"]

        note.pop('_id', None)  # Prevent inserting _id: null or _id: ''
        result = mongo.db.notes.insert_one(note)

        # ✅ Format and return note with 'id' instead of '_id'
        note["id"] = str(result.inserted_id)
        print("Note inserted:", note)

        return {"message": "Note added successfully", "note": note}
    except Exception as e:
        print("Exception:", e)
        raise HTTPException(status_code=500, detail=str(e))




@router.get("/notes")
def get_notes():
    notes = []
    for note in mongo.db.notes.find():
        note["id"] = str(note["_id"])
        del note["_id"]
        notes.append(note)
    return notes



@router.delete("/notes/{note_id}")
async def delete_note(note_id: str):
    try:
        result = mongo.db.notes.delete_one({"_id": ObjectId(note_id)})
        if result.deleted_count == 1:
            return {"message": "Note deleted successfully"}
        else:
            raise HTTPException(status_code=404, detail="Note not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
