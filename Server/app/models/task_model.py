from pydantic import BaseModel
from typing import Optional

class Task(BaseModel):
    id: Optional[str]
    title: str
    is_completed: bool = False
