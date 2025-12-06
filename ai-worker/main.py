#!/usr/bin/env python3
"""
PocketMind AI Worker
Processes AI tasks from RabbitMQ queue:
- Transcribes audio using Whisper
- Generates embeddings using SentenceTransformers
- Stores vectors in Qdrant
- Generates summaries using local LLM
"""

import json
import logging
import os
import sys
from typing import Dict, Any

import pika
import requests
from minio import Minio
from minio.error import S3Error
from sentence_transformers import SentenceTransformer
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct
import whisper

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class AIWorker:
    def __init__(self):
        # Configuration from environment
        self.rabbitmq_host = os.getenv('RABBITMQ_HOST', 'localhost')
        self.rabbitmq_queue = os.getenv('RABBITMQ_QUEUE', 'ai.tasks')
        self.minio_endpoint = os.getenv('MINIO_ENDPOINT', 'localhost:9000')
        self.minio_access_key = os.getenv('MINIO_ACCESS_KEY', 'minioadmin')
        self.minio_secret_key = os.getenv('MINIO_SECRET_KEY', 'minioadmin')
        self.minio_bucket = os.getenv('MINIO_BUCKET', 'pocketmind-files')
        self.qdrant_host = os.getenv('QDRANT_HOST', 'localhost')
        self.qdrant_port = int(os.getenv('QDRANT_PORT', '6333'))
        self.backend_url = os.getenv('BACKEND_URL', 'http://localhost:8080')
        
        # Initialize services
        self.minio_client = Minio(
            self.minio_endpoint,
            access_key=self.minio_access_key,
            secret_key=self.minio_secret_key,
            secure=False
        )
        
        self.qdrant_client = QdrantClient(
            host=self.qdrant_host,
            port=self.qdrant_port
        )
        
        # Initialize AI models
        logger.info("Loading AI models...")
        self.embedding_model = SentenceTransformer('all-MiniLM-L6-v2')
        self.whisper_model = whisper.load_model("base")
        logger.info("AI models loaded successfully")
        
        # Initialize Qdrant collection if it doesn't exist
        self._init_qdrant_collection()
    
    def _init_qdrant_collection(self):
        """Initialize Qdrant collection for embeddings"""
        collection_name = "memories"
        try:
            collections = self.qdrant_client.get_collections()
            collection_names = [c.name for c in collections.collections]
            
            if collection_name not in collection_names:
                self.qdrant_client.create_collection(
                    collection_name=collection_name,
                    vectors_config=VectorParams(
                        size=384,  # all-MiniLM-L6-v2 dimension
                        distance=Distance.COSINE
                    )
                )
                logger.info(f"Created Qdrant collection: {collection_name}")
        except Exception as e:
            logger.error(f"Error initializing Qdrant collection: {e}")
    
    def process_task(self, task: Dict[str, Any]):
        """Process a single AI task"""
        memory_id = task.get('memoryId')
        file_type = task.get('fileType')
        file_url = task.get('fileUrl')
        file_name = task.get('fileName')
        
        logger.info(f"Processing task for memory {memory_id}, type: {file_type}")
        
        try:
            # Update status to PROCESSING
            self._update_memory_status(memory_id, 'PROCESSING')
            
            content = None
            summary = None
            embedding_id = None
            
            if file_type == 'AUDIO':
                content, summary = self._process_audio(file_name)
            elif file_type == 'TEXT':
                # For text, content is already in the memory
                # We'll fetch it or it should be in the task
                content = task.get('content', '')
                summary = self._generate_summary(content)
            elif file_type == 'IMAGE':
                # Image processing would use OCR or vision models
                # For now, we'll generate a placeholder
                content = "Image uploaded"
                summary = "Image content processing not yet implemented"
            
            # Generate embedding and store in Qdrant
            if content:
                embedding_id = self._store_embedding(memory_id, content)
            
            # Send callback to Spring Boot
            self._notify_complete(memory_id, content, summary, embedding_id)
            
            logger.info(f"Successfully processed memory {memory_id}")
            
        except Exception as e:
            logger.error(f"Error processing task for memory {memory_id}: {e}", exc_info=True)
            self._update_memory_status(memory_id, 'FAILED')
    
    def _process_audio(self, file_name: str) -> tuple[str, str]:
        """Transcribe audio file using Whisper"""
        logger.info(f"Transcribing audio: {file_name}")
        
        # Download file from MinIO
        local_path = f"/tmp/{file_name}"
        try:
            self.minio_client.fget_object(self.minio_bucket, file_name, local_path)
        except S3Error as e:
            logger.error(f"Error downloading file from MinIO: {e}")
            raise
        
        # Transcribe with Whisper
        try:
            result = self.whisper_model.transcribe(local_path)
            content = result["text"]
            
            # Generate summary
            summary = self._generate_summary(content)
            
            # Clean up local file
            os.remove(local_path)
            
            return content, summary
        except Exception as e:
            logger.error(f"Error transcribing audio: {e}")
            if os.path.exists(local_path):
                os.remove(local_path)
            raise
    
    def _generate_summary(self, content: str) -> str:
        """Generate summary using local LLM (simplified - in production use Llama.cpp)"""
        # For now, return a simple summary
        # In production, integrate with Llama.cpp via llama-cpp-python
        words = content.split()
        if len(words) > 50:
            return ' '.join(words[:50]) + '...'
        return content
    
    def _store_embedding(self, memory_id: int, content: str) -> str:
        """Generate embedding and store in Qdrant"""
        logger.info(f"Generating embedding for memory {memory_id}")
        
        # Generate embedding
        embedding = self.embedding_model.encode(content).tolist()
        
        # Store in Qdrant
        point = PointStruct(
            id=memory_id,
            vector=embedding,
            payload={"memory_id": memory_id, "content": content[:500]}  # Store first 500 chars
        )
        
        self.qdrant_client.upsert(
            collection_name="memories",
            points=[point]
        )
        
        logger.info(f"Stored embedding for memory {memory_id}")
        return str(memory_id)
    
    def _update_memory_status(self, memory_id: int, status: str):
        """Update memory processing status"""
        # This would typically be done via Spring Boot API
        # For now, we'll include it in the final callback
        pass
    
    def _notify_complete(self, memory_id: int, content: str, summary: str, embedding_id: str):
        """Notify Spring Boot that processing is complete"""
        url = f"{self.backend_url}/api/callback/process-complete"
        payload = {
            "memoryId": memory_id,
            "content": content,
            "summary": summary,
            "embeddingId": embedding_id
        }
        
        try:
            response = requests.post(url, json=payload)
            response.raise_for_status()
            logger.info(f"Notified backend of completion for memory {memory_id}")
        except Exception as e:
            logger.error(f"Error notifying backend: {e}")
            raise
    
    def _search_vectors(self, query: str, limit: int = 10) -> list:
        """Search for similar memories using vector search"""
        # Generate query embedding
        query_embedding = self.embedding_model.encode(query).tolist()
        
        # Search in Qdrant
        results = self.qdrant_client.search(
            collection_name="memories",
            query_vector=query_embedding,
            limit=limit
        )
        
        return [
            {"memoryId": result.id, "score": result.score}
            for result in results
        ]
    
    def start_consuming(self):
        """Start consuming messages from RabbitMQ"""
        connection = pika.BlockingConnection(
            pika.ConnectionParameters(host=self.rabbitmq_host)
        )
        channel = connection.channel()
        
        channel.queue_declare(queue=self.rabbitmq_queue, durable=True)
        channel.basic_qos(prefetch_count=1)
        
        def callback(ch, method, properties, body):
            try:
                task = json.loads(body)
                self.process_task(task)
                ch.basic_ack(delivery_tag=method.delivery_tag)
            except Exception as e:
                logger.error(f"Error processing message: {e}", exc_info=True)
                ch.basic_nack(delivery_tag=method.delivery_tag, requeue=False)
        
        channel.basic_consume(
            queue=self.rabbitmq_queue,
            on_message_callback=callback
        )
        
        logger.info(f"Waiting for messages on queue: {self.rabbitmq_queue}")
        channel.start_consuming()


def main():
    """Main entry point"""
    worker = AIWorker()
    try:
        worker.start_consuming()
    except KeyboardInterrupt:
        logger.info("Shutting down worker...")
        sys.exit(0)


if __name__ == '__main__':
    main()

