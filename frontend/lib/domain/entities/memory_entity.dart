/// Domain entity - pure business logic, no framework dependencies
class MemoryEntity {
  final String id;
  final String title;
  final String? content;
  final String? summary;
  final String? fileUrl;
  final FileTypeEntity fileType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProcessingStatusEntity processingStatus;
  final List<TagEntity> tags;
  final String? embeddingId;

  MemoryEntity({
    required this.id,
    required this.title,
    this.content,
    this.summary,
    this.fileUrl,
    required this.fileType,
    required this.createdAt,
    required this.updatedAt,
    required this.processingStatus,
    required this.tags,
    this.embeddingId,
  });

  bool get isProcessed => processingStatus == ProcessingStatusEntity.completed;
  bool get isProcessing => processingStatus == ProcessingStatusEntity.processing;
  bool get hasFailed => processingStatus == ProcessingStatusEntity.failed;

  MemoryEntity copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    String? fileUrl,
    FileTypeEntity? fileType,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProcessingStatusEntity? processingStatus,
    List<TagEntity>? tags,
    String? embeddingId,
  }) {
    return MemoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      processingStatus: processingStatus ?? this.processingStatus,
      tags: tags ?? this.tags,
      embeddingId: embeddingId ?? this.embeddingId,
    );
  }
}

enum FileTypeEntity {
  audio,
  image,
  text;

  String get displayName {
    switch (this) {
      case FileTypeEntity.audio:
        return 'Audio';
      case FileTypeEntity.image:
        return 'Image';
      case FileTypeEntity.text:
        return 'Text';
    }
  }
}

enum ProcessingStatusEntity {
  pending,
  processing,
  completed,
  failed;

  String get displayName {
    switch (this) {
      case ProcessingStatusEntity.pending:
        return 'Pending';
      case ProcessingStatusEntity.processing:
        return 'Processing';
      case ProcessingStatusEntity.completed:
        return 'Completed';
      case ProcessingStatusEntity.failed:
        return 'Failed';
    }
  }
}

class TagEntity {
  final String id;
  final String name;
  final String? color;

  TagEntity({
    required this.id,
    required this.name,
    this.color,
  });
}

