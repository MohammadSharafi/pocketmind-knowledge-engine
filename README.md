# PocketMind LocalAI

A cross-platform AI-assisted personal knowledge engine that processes audio notes, images, and text into structured, searchable memories using local AI models.

## Architecture

- **Frontend**: Flutter app with BLoC state management
- **Backend**: Spring Boot GraphQL API
- **AI Worker**: Python service for transcription, embeddings, and summarization
- **Storage**: PostgreSQL (metadata), MinIO (files), Qdrant (vectors)
- **Message Queue**: RabbitMQ for async task processing

## Services

1. **Spring Boot Backend** (`backend/`) - GraphQL API, orchestrates workflows
2. **Python AI Worker** (`ai-worker/`) - Processes AI tasks locally
3. **Flutter Frontend** (`frontend/`) - Cross-platform mobile app

## Quick Start

1. Start infrastructure services:
```bash
cd docker
docker-compose up -d
```

2. Start Spring Boot backend:
```bash
cd backend
./mvnw spring-boot:run
```

3. Start Python AI worker:
```bash
cd ai-worker
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python main.py
```

4. Run Flutter app:
```bash
cd frontend
flutter pub get
flutter run
```

## Technology Stack

- **Frontend**: Flutter, BLoC, graphql_flutter
- **Backend**: Spring Boot, Spring GraphQL, JPA, PostgreSQL
- **AI**: Whisper.cpp, SentenceTransformers, Llama.cpp, Qdrant
- **Infrastructure**: Docker, MinIO, RabbitMQ

