FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ app/
COPY migrations/ migrations/
COPY scripts/ scripts/

# Add migration script to the container
COPY scripts/run_migrations.py .

# Make the script executable
RUN chmod +x run_migrations.py

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"] 