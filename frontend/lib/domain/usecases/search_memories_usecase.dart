import '../repositories/memory_repository.dart';

class SearchMemoriesUseCase {
  final MemoryRepository repository;

  SearchMemoriesUseCase(this.repository);

  Future<List<SearchResultEntity>> call(String query, {int limit = 10}) {
    if (query.trim().isEmpty) {
      throw ArgumentError('Search query cannot be empty');
    }
    return repository.searchMemories(query, limit: limit);
  }
}

