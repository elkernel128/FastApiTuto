import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

class Database:
    def __init__(self):
        self.supabase: Client = create_client(
            os.getenv("SUPABASE_URL"),
            os.getenv("SUPABASE_KEY")
        )

    def save_conversation(self, user_id: str, message: str, response: str):
        data = {
            "user_id": user_id,
            "message": message,
            "response": response
        }
        return self.supabase.table("conversations").insert(data).execute()

    def search_conversations(self, user_id: str, query: str):
        return self.supabase.table("conversations")\
            .select("*")\
            .filter("user_id", "eq", user_id)\
            .filter("message", "ilike", f"%{query}%")\
            .execute()

db = Database() 