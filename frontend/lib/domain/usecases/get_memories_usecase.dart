import '../entities/memory_entity.dart';
import '../repositories/memory_repository.dart';

/// Use case - encapsulates business logic
class GetMemoriesUseCase {
  final MemoryRepository repository;

  GetMemoriesUseCase(this.repository);

  Future<List<MemoryEntity>> call({int? limit, int? offset}) {
    return repository.getMemories(limit: limit, offset: offset);
  }
}

