import '../entities/memory_entity.dart';
import '../repositories/memory_repository.dart';

class CreateTextMemoryUseCase {
  final MemoryRepository repository;

  CreateTextMemoryUseCase(this.repository);

  Future<MemoryEntity> call(String content, {String? title}) {
    if (content.trim().isEmpty) {
      throw ArgumentError('Content cannot be empty');
    }
    return repository.createTextMemory(content, title: title);
  }
}

