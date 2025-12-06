import '../entities/memory_entity.dart';

/// Repository interface - part of domain layer
/// Defines what operations are needed, not how they're implemented
abstract class MemoryRepository {
  Future<List<MemoryEntity>> getMemories({int? limit, int? offset});
  Future<MemoryEntity> getMemoryById(String id);
  Future<MemoryEntity> createTextMemory(String content, {String? title});
  Future<MemoryEntity> uploadAudio(String filePath);
  Future<MemoryEntity> uploadImage(String filePath);
  Future<void> deleteMemory(String id);
  Future<List<SearchResultEntity>> searchMemories(String query, {int limit = 10});
}

class SearchResultEntity {
  final MemoryEntity memory;
  final double score;

  SearchResultEntity({
    required this.memory,
    required this.score,
  });
}

