import '../../domain/entities/memory_entity.dart';

/// Data model - extends domain entity with serialization
class MemoryModel extends MemoryEntity {
  MemoryModel({
    required super.id,
    required super.title,
    super.content,
    super.summary,
    super.fileUrl,
    required super.fileType,
    required super.createdAt,
    required super.updatedAt,
    required super.processingStatus,
    required super.tags,
    super.embeddingId,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      content: json['content'],
      summary: json['summary'],
      fileUrl: json['fileUrl'],
      fileType: _fileTypeFromString(json['fileType'] ?? 'TEXT'),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      processingStatus: _statusFromString(json['processingStatus'] ?? 'PENDING'),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => TagModel.fromJson(tag))
              .toList() ??
          [],
      embeddingId: json['embeddingId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'fileUrl': fileUrl,
      'fileType': fileType.name.toUpperCase(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'processingStatus': processingStatus.name.toUpperCase(),
      'tags': tags.map((tag) => (tag as TagModel).toJson()).toList(),
      'embeddingId': embeddingId,
    };
  }

  MemoryEntity toEntity() {
    return MemoryEntity(
      id: id,
      title: title,
      content: content,
      summary: summary,
      fileUrl: fileUrl,
      fileType: fileType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      processingStatus: processingStatus,
      tags: tags.map((t) => TagEntity(id: t.id, name: t.name, color: t.color)).toList(),
      embeddingId: embeddingId,
    );
  }

  static FileTypeEntity _fileTypeFromString(String value) {
    switch (value.toUpperCase()) {
      case 'AUDIO':
        return FileTypeEntity.audio;
      case 'IMAGE':
        return FileTypeEntity.image;
      case 'TEXT':
        return FileTypeEntity.text;
      default:
        return FileTypeEntity.text;
    }
  }

  static ProcessingStatusEntity _statusFromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return ProcessingStatusEntity.pending;
      case 'PROCESSING':
        return ProcessingStatusEntity.processing;
      case 'COMPLETED':
        return ProcessingStatusEntity.completed;
      case 'FAILED':
        return ProcessingStatusEntity.failed;
      default:
        return ProcessingStatusEntity.pending;
    }
  }
}

class TagModel extends TagEntity {
  TagModel({required super.id, required super.name, super.color});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}

class SearchResultModel {
  final MemoryModel memory;
  final double score;

  SearchResultModel({required this.memory, required this.score});

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      memory: MemoryModel.fromJson(json['memory']),
      score: (json['score'] as num).toDouble(),
    );
  }
}

