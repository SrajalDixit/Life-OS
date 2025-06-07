from fastapi import APIRouter, HTTPException
import httpx, os
from dotenv import load_dotenv

load_dotenv()
router = APIRouter()

@router.get("/models")
async def get_models():
    
    api_key = os.getenv("OPENROUTER_API_KEY")
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://openrouter.ai/api/v1/models",
            headers={"Authorization": f"Bearer {api_key}"}
        )
    return response.json()


@router.post("/chatbot")
async def chatbot(message: dict):
    api_key = os.getenv("OPENROUTER_API_KEY")
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://openrouter.ai/api/v1/chat/completions",
                headers={
                    "Authorization": f"Bearer {api_key}",
                    "Content-Type": "application/json",
                },
                json={
                    "model": "deepseek/deepseek-r1-0528-qwen3-8b:free",  # working model
                    "messages": [{"role": "user", "content": message["message"]}]
                }
            )
        return response.json()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
