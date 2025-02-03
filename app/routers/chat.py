from fastapi import APIRouter, HTTPException
from app.models import ChatRequest, ChatResponse, SearchRequest, SearchResponse
from app.services.openai_service import openai_service
from app.database import db

router = APIRouter()

@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    try:
        response = await openai_service.get_chat_response(request.message)
        db.save_conversation(request.user_id, request.message, response)
        return ChatResponse(response=response)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/search", response_model=SearchResponse)
async def search_conversations(request: SearchRequest):
    try:
        result = db.search_conversations(request.user_id, request.query)
        return SearchResponse(conversations=result.data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 