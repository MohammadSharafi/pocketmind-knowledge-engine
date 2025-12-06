#!/usr/bin/env python3
"""
REST API for semantic search
Exposes endpoint for Spring Boot to query Qdrant
"""

from flask import Flask, request, jsonify
from sentence_transformers import SentenceTransformer
from qdrant_client import QdrantClient
import os
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Initialize models and clients
embedding_model = SentenceTransformer('all-MiniLM-L6-v2')
qdrant_client = QdrantClient(
    host=os.getenv('QDRANT_HOST', 'localhost'),
    port=int(os.getenv('QDRANT_PORT', '6333'))
)

@app.route('/search', methods=['POST'])
def search():
    """Perform semantic search"""
    data = request.json
    query = data.get('query')
    limit = data.get('limit', 10)
    
    if not query:
        return jsonify({'error': 'Query is required'}), 400
    
    try:
        # Generate query embedding
        query_embedding = embedding_model.encode(query).tolist()
        
        # Search in Qdrant
        results = qdrant_client.search(
            collection_name="memories",
            query_vector=query_embedding,
            limit=limit
        )
        
        # Format results
        formatted_results = [
            {
                "memoryId": result.id,
                "score": float(result.score)
            }
            for result in results
        ]
        
        return jsonify({'results': formatted_results})
    except Exception as e:
        logger.error(f"Error performing search: {e}", exc_info=True)
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    app.run(host='0.0.0.0', port=port, debug=True)

