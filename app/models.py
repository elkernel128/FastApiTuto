from pydantic import BaseModel
from typing import List, Optional

class ChatRequest(BaseModel):
    message: str
    user_id: str

class ChatResponse(BaseModel):
    response: str

class SearchRequest(BaseModel):
    user_id: str
    query: str

class Conversation(BaseModel):
    id: int
    user_id: str
    message: str
    response: str
    created_at: str

class SearchResponse(BaseModel):
    conversations: List[Conversation] 