import '../../domain/entities/memory_entity.dart';
import '../../domain/repositories/memory_repository.dart';
import '../datasources/memory_remote_datasource.dart';
import '../datasources/memory_file_datasource.dart';
import '../models/memory_model.dart';
import 'dart:io';

/// Repository implementation - bridges domain and data layers
class MemoryRepositoryImpl implements MemoryRepository {
  final MemoryRemoteDataSource remoteDataSource;
  final MemoryFileDataSource fileDataSource;

  MemoryRepositoryImpl({
    required this.remoteDataSource,
    required this.fileDataSource,
  });

  @override
  Future<List<MemoryEntity>> getMemories({int? limit, int? offset}) async {
    final models = await remoteDataSource.getMemories(limit: limit, offset: offset);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MemoryEntity> getMemoryById(String id) async {
    final model = await remoteDataSource.getMemoryById(id);
    return model.toEntity();
  }

  @override
  Future<MemoryEntity> createTextMemory(String content, {String? title}) async {
    final model = await remoteDataSource.createTextMemory(content, title: title);
    return model.toEntity();
  }

  @override
  Future<MemoryEntity> uploadAudio(String filePath) async {
    final file = File(filePath);
    final model = await fileDataSource.uploadAudio(file);
    return model.toEntity();
  }

  @override
  Future<MemoryEntity> uploadImage(String filePath) async {
    final file = File(filePath);
    final model = await fileDataSource.uploadImage(file);
    return model.toEntity();
  }

  @override
  Future<void> deleteMemory(String id) async {
    await remoteDataSource.deleteMemory(id);
  }

  @override
  Future<List<SearchResultEntity>> searchMemories(String query, {int limit = 10}) async {
    final results = await remoteDataSource.searchMemories(query, limit: limit);
    return results.map((r) => SearchResultEntity(
      memory: r.memory.toEntity(),
      score: r.score,
    )).toList();
  }
}

