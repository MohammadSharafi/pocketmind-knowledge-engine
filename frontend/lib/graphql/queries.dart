class GraphQLQueries {
  static const String getMemories = '''
    query GetMemories(\$limit: Int, \$offset: Int) {
      memories(limit: \$limit, offset: \$offset) {
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

  static const String getMemory = '''
    query GetMemory(\$id: ID!) {
      memory(id: \$id) {
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

  static const String search = '''
    query Search(\$query: String!, \$limit: Int) {
      search(query: \$query, limit: \$limit) {
        memory {
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
        score
      }
    }
  ''';

  static const String getTags = '''
    query GetTags {
      tags {
        id
        name
        color
      }
    }
  ''';
}

