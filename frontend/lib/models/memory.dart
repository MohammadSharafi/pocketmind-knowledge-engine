class Memory {
  final String id;
  final String title;
  final String? content;
  final String? summary;
  final String? fileUrl;
  final FileType fileType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProcessingStatus processingStatus;
  final List<Tag> tags;
  final String? embeddingId;

  Memory({
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

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      content: json['content'],
      summary: json['summary'],
      fileUrl: json['fileUrl'],
      fileType: FileType.fromString(json['fileType'] ?? 'TEXT'),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      processingStatus: ProcessingStatus.fromString(
          json['processingStatus'] ?? 'PENDING'),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => Tag.fromJson(tag))
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
      'fileType': fileType.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'processingStatus': processingStatus.toString().split('.').last,
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'embeddingId': embeddingId,
    };
  }
}

enum FileType {
  audio,
  image,
  text;

  static FileType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'AUDIO':
        return FileType.audio;
      case 'IMAGE':
        return FileType.image;
      case 'TEXT':
        return FileType.text;
      default:
        return FileType.text;
    }
  }
}

enum ProcessingStatus {
  pending,
  processing,
  completed,
  failed;

  static ProcessingStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return ProcessingStatus.pending;
      case 'PROCESSING':
        return ProcessingStatus.processing;
      case 'COMPLETED':
        return ProcessingStatus.completed;
      case 'FAILED':
        return ProcessingStatus.failed;
      default:
        return ProcessingStatus.pending;
    }
  }
}

class Tag {
  final String id;
  final String name;
  final String? color;

  Tag({
    required this.id,
    required this.name,
    this.color,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
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

class SearchResult {
  final Memory memory;
  final double score;

  SearchResult({
    required this.memory,
    required this.score,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      memory: Memory.fromJson(json['memory']),
      score: (json['score'] as num).toDouble(),
    );
  }
}

