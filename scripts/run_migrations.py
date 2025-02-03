import os
from supabase import create_client
from dotenv import load_dotenv
import glob

load_dotenv()

def run_migrations():
    supabase = create_client(
        os.getenv("SUPABASE_URL"),
        os.getenv("SUPABASE_KEY")
    )
    
    # Get all .sql files from migrations directory
    migration_files = sorted(glob.glob('migrations/*.sql'))
    
    for migration_file in migration_files:
        print(f"Running migration: {migration_file}")
        with open(migration_file, 'r') as f:
            sql = f.read()
            try:
                # Execute the SQL directly using the REST API
                supabase.postgrest.rpc('run_sql', {'sql': sql}).execute()
                print(f"Successfully executed {migration_file}")
            except Exception as e:
                print(f"Error executing {migration_file}: {str(e)}")
                raise e

if __name__ == "__main__":
    run_migrations() 