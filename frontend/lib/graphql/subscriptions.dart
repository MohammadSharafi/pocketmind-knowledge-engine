class GraphQLSubscriptions {
  static const String memoryProcessed = '''
    subscription MemoryProcessed(\$memoryId: ID!) {
      memoryProcessed(memoryId: \$memoryId) {
        id
        title
        content
        summary
        fileUrl
        fileType
        createdAt
        updatedAt
        processingStatus
        tags {
          id
          name
          color
        }
        embeddingId
      }
    }
  ''';

  static const String memoryUpdated = '''
    subscription MemoryUpdated {
      memoryUpdated {
        id
        title
        content
        summary
        fileUrl
        fileType
        createdAt
        updatedAt
        processingStatus
        tags {
          id
          name
          color
        }
        embeddingId
      }
    }
  ''';
}

