# PocketMind LocalAI - Project Summary

## Overview

PocketMind LocalAI is a complete cross-platform AI-assisted personal knowledge engine that processes audio notes, images, and text into structured, searchable memories using entirely local AI models.

## Architecture

### Components

1. **Flutter Frontend** (`frontend/`)
   - BLoC state management
   - GraphQL client with subscriptions
   - Audio recording
   - File/image pickers
   - Material 3 UI

2. **Spring Boot Backend** (`backend/`)
   - GraphQL API (Spring GraphQL)
   - REST endpoints for file uploads
   - PostgreSQL for metadata
   - MinIO integration for file storage
   - RabbitMQ for task queue
   - GraphQL subscriptions for real-time updates

3. **Python AI Worker** (`ai-worker/`)
   - Whisper for audio transcription
   - SentenceTransformers for embeddings
   - Qdrant for vector storage
   - REST API for semantic search
   - RabbitMQ consumer

4. **Infrastructure** (`docker/`)
   - PostgreSQL database
   - MinIO object storage
   - Qdrant vector database
   - RabbitMQ message broker

## Key Features

✅ **Audio Transcription**: Record and transcribe audio notes using Whisper
✅ **Text Processing**: Create text memories with AI summarization
✅ **Image Upload**: Upload and process images (extensible for OCR)
✅ **Semantic Search**: Find memories using vector similarity search
✅ **Real-time Updates**: GraphQL subscriptions notify when processing completes
✅ **Tag Management**: Organize memories with tags
✅ **Local AI**: All processing happens locally, no external APIs

## Technology Stack

### Frontend
- Flutter 3.8+
- BLoC pattern
- graphql_flutter
- record (audio)
- file_picker, image_picker

### Backend
- Spring Boot 3.2
- Spring GraphQL
- PostgreSQL
- MinIO
- RabbitMQ
- JPA/Hibernate

### AI Worker
- Python 3.9+
- OpenAI Whisper
- SentenceTransformers
- Qdrant Client
- Pika (RabbitMQ)
- Flask (search API)

## Project Structure

```
pocketmind-localai/
├── backend/                 # Spring Boot application
│   ├── src/main/java/
│   │   └── com/pocketmind/
│   │       ├── model/      # JPA entities
│   │       ├── repository/ # Data repositories
│   │       ├── service/    # Business logic
│   │       ├── resolver/   # GraphQL resolvers
│   │       ├── storage/    # MinIO service
│   │       ├── queue/      # RabbitMQ service
│   │       └── config/     # Configuration
│   └── src/main/resources/
│       ├── application.yml
│       └── schema.graphqls
│
├── ai-worker/              # Python AI service
│   ├── main.py            # Main worker process
│   ├── search_api.py      # Search REST API
│   └── requirements.txt
│
├── frontend/              # Flutter application
│   └── lib/
│       ├── bloc/          # BLoC state management
│       ├── models/        # Data models
│       ├── services/      # API services
│       ├── screens/       # UI screens
│       ├── widgets/       # Reusable widgets
│       └── graphql/       # GraphQL queries/mutations
│
└── docker/                # Infrastructure
    └── docker-compose.yml
```

## Data Flow

1. **Upload Flow**:
   ```
   Flutter → REST API → Spring Boot → MinIO (store file)
   Spring Boot → RabbitMQ → Python Worker
   Python Worker → Process → Qdrant (store embedding)
   Python Worker → Spring Boot (callback)
   Spring Boot → GraphQL Subscription → Flutter (update UI)
   ```

2. **Search Flow**:
   ```
   Flutter → GraphQL Query → Spring Boot
   Spring Boot → Python Search API
   Python → Generate query embedding → Qdrant search
   Python → Return results → Spring Boot → Flutter
   ```

## Getting Started

See [SETUP.md](./SETUP.md) for detailed setup instructions.

Quick start:
1. `cd docker && docker-compose up -d`
2. `cd backend && ./mvnw spring-boot:run`
3. `cd ai-worker && python main.py`
4. `cd frontend && flutter run`

## Configuration

All configuration is environment-based:
- Backend: `application.yml`
- Python Worker: Environment variables or `.env`
- Flutter: `lib/graphql/graphql_client.dart`

## Future Enhancements

- [ ] Llama.cpp integration for better summarization
- [ ] Image OCR using local models
- [ ] User authentication and multi-user support
- [ ] Advanced tag management with hierarchies
- [ ] Export/import functionality
- [ ] Offline mode support
- [ ] Mobile app optimizations
- [ ] Analytics and insights

## License

This is a personal project. Customize as needed.

## Notes

- First run will download AI models (~600MB total)
- Ensure sufficient disk space for models
- For mobile devices, update GraphQL endpoint to use machine IP
- All services must be running for full functionality

