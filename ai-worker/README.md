# PocketMind AI Worker

Python service that processes AI tasks from RabbitMQ queue.

## Features

- **Audio Transcription**: Uses OpenAI Whisper for speech-to-text
- **Embeddings**: Generates vector embeddings using SentenceTransformers (all-MiniLM-L6-v2)
- **Vector Storage**: Stores embeddings in Qdrant for semantic search
- **Summarization**: Generates summaries (can be extended with Llama.cpp)

## Setup

1. Install dependencies:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

2. Download Whisper model (first run will download automatically):
```bash
# Model is downloaded automatically on first use
```

3. Set environment variables (or use .env file):
```bash
export RABBITMQ_HOST=localhost
export MINIO_ENDPOINT=localhost:9000
export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin
export QDRANT_HOST=localhost
export BACKEND_URL=http://localhost:8080
```

4. Run the worker:
```bash
python main.py
```

5. Run the search API (optional, separate process):
```bash
python search_api.py
```

## Architecture

- Listens to RabbitMQ queue `ai.tasks`
- Downloads files from MinIO
- Processes with AI models
- Stores results in Qdrant
- Sends callback to Spring Boot backend

