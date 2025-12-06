class GraphQLMutations {
  static const String uploadText = '''
    mutation UploadText(\$content: String!, \$title: String) {
      uploadText(content: \$content, title: \$title) {
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

  static const String createTag = '''
    mutation CreateTag(\$name: String!, \$color: String) {
      createTag(name: \$name, color: \$color) {
        id
        name
        color
      }
    }
  ''';

  static const String addTagToMemory = '''
    mutation AddTagToMemory(\$memoryId: ID!, \$tagId: ID!) {
      addTagToMemory(memoryId: \$memoryId, tagId: \$tagId) {
        id
        title
        tags {
          id
          name
          color
        }
      }
    }
  ''';

  static const String removeTagFromMemory = '''
    mutation RemoveTagFromMemory(\$memoryId: ID!, \$tagId: ID!) {
      removeTagFromMemory(memoryId: \$memoryId, tagId: \$tagId) {
        id
        title
        tags {
          id
          name
          color
        }
      }
    }
  ''';

  static const String deleteMemory = '''
    mutation DeleteMemory(\$id: ID!) {
      deleteMemory(id: \$id)
    }
  ''';
}

