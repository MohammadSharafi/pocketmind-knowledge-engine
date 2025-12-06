# PocketMind LocalAI Setup Guide

This guide will help you set up and run the complete PocketMind LocalAI system.

## Prerequisites

- Docker and Docker Compose
- Java 17+ (for Spring Boot)
- Maven 3.6+
- Python 3.9+
- Flutter 3.8+
- Node.js (for some Python dependencies)

## Step 1: Start Infrastructure Services

Start all infrastructure services using Docker Compose:

```bash
cd docker
docker-compose up -d
```

This will start:
- PostgreSQL (port 5432)
- MinIO (ports 9000, 9001)
- Qdrant (ports 6333, 6334)
- RabbitMQ (ports 5672, 15672)

Verify services are running:
```bash
docker-compose ps
```

Access MinIO Console: http://localhost:9001 (minioadmin/minioadmin)
Access RabbitMQ Management: http://localhost:15672 (guest/guest)

## Step 2: Set Up Spring Boot Backend

1. Navigate to backend directory:
```bash
cd backend
```

2. Build and run:
```bash
./mvnw spring-boot:run
```

Or if you have Maven installed:
```bash
mvn spring-boot:run
```

The backend will start on http://localhost:8080
GraphQL endpoint: http://localhost:8080/graphql
GraphiQL UI: http://localhost:8080/graphiql

## Step 3: Set Up Python AI Worker

1. Navigate to ai-worker directory:
```bash
cd ai-worker
```

2. Create virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

**Note**: The first run will download Whisper models (~500MB) and SentenceTransformer models (~90MB). This may take several minutes.

4. Run the worker:
```bash
python main.py
```

5. (Optional) Run the search API in a separate terminal:
```bash
python search_api.py
```

## Step 4: Set Up Flutter Frontend

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Get dependencies:
```bash
flutter pub get
```

3. Update GraphQL endpoint if needed:
   - Edit `lib/graphql/graphql_client.dart`
   - Change `graphqlEndpoint` and `wsEndpoint` if your backend runs on a different host/port

4. Run the app:
```bash
flutter run
```

For iOS simulator or Android emulator, make sure to update the endpoint to use your machine's IP address instead of `localhost`.

## Configuration

### Backend Configuration

Edit `backend/src/main/resources/application.yml` to customize:
- Database connection
- MinIO settings
- RabbitMQ settings
- AI worker URL

### Python Worker Configuration

Create a `.env` file in `ai-worker/` directory:
```env
RABBITMQ_HOST=localhost
RABBITMQ_QUEUE=ai.tasks
MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_BUCKET=pocketmind-files
QDRANT_HOST=localhost
QDRANT_PORT=6333
BACKEND_URL=http://localhost:8080
PORT=8000
```

### Flutter Configuration

For mobile devices, update the GraphQL endpoint in `lib/graphql/graphql_client.dart`:
- iOS Simulator: Use `localhost`
- Android Emulator: Use `10.0.2.2`
- Physical Device: Use your machine's IP address (e.g., `192.168.1.100`)

## Testing the System

1. **Upload Text Memory**:
   - Open Flutter app
   - Tap the + button
   - Enter text and save
   - Check backend logs for processing

2. **Upload Audio**:
   - Tap + button
   - Start recording
   - Stop and upload
   - Wait for transcription (check Python worker logs)

3. **Search**:
   - Use the search icon
   - Enter a query
   - Results are ranked by semantic similarity

## Troubleshooting

### Backend won't start
- Check PostgreSQL is running: `docker ps`
- Verify database credentials in `application.yml`
- Check port 8080 is not in use

### Python worker errors
- Ensure RabbitMQ is running
- Check MinIO is accessible
- Verify all dependencies are installed
- Check Python version (3.9+ required)

### Flutter connection issues
- For physical devices, ensure backend and device are on same network
- Check firewall settings
- Verify GraphQL endpoint URL is correct
- For Android, use `10.0.2.2` instead of `localhost`

### Audio transcription not working
- First run downloads Whisper models (be patient)
- Check disk space (models are large)
- Verify audio file format is supported

## Architecture Overview

```
Flutter App (Frontend)
    ↓ GraphQL
Spring Boot (Backend)
    ↓ REST API
    ↓ RabbitMQ
Python AI Worker
    ↓ MinIO (File Storage)
    ↓ Qdrant (Vector DB)
    ↓ PostgreSQL (Metadata)
```

## Next Steps

- Integrate Llama.cpp for better summarization
- Add image OCR capabilities
- Implement user authentication
- Add more sophisticated tag management
- Enhance UI/UX with animations
- Add offline support

## Production Deployment

For production:
1. Use environment variables for all configuration
2. Set up proper SSL/TLS certificates
3. Configure database backups
4. Use production-grade message queue setup
5. Implement proper logging and monitoring
6. Set up CI/CD pipelines
7. Use container orchestration (Kubernetes)

