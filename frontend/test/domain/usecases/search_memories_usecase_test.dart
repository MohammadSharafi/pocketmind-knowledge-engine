import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pocketmind/domain/repositories/memory_repository.dart';
import 'package:pocketmind/domain/usecases/search_memories_usecase.dart';
import 'package:pocketmind/domain/entities/memory_entity.dart';

import 'search_memories_usecase_test.mocks.dart';

@GenerateMocks([MemoryRepository])
void main() {
  late SearchMemoriesUseCase useCase;
  late MockMemoryRepository mockRepository;

  setUp(() {
    mockRepository = MockMemoryRepository();
    useCase = SearchMemoriesUseCase(mockRepository);
  });

  final testMemory = MemoryEntity(
    id: '1',
    title: 'Test Memory',
    content: 'Test content',
    fileType: FileTypeEntity.text,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    processingStatus: ProcessingStatusEntity.completed,
    tags: [],
  );

  final testSearchResult = SearchResultEntity(
    memory: testMemory,
    score: 0.95,
  );

  test('should search memories successfully', () async {
    // Arrange
    when(mockRepository.searchMemories('test query', limit: 10))
        .thenAnswer((_) async => [testSearchResult]);

    // Act
    final result = await useCase('test query');

    // Assert
    expect(result, [testSearchResult]);
    expect(result.first.score, 0.95);
    verify(mockRepository.searchMemories('test query', limit: 10));
  });

  test('should throw ArgumentError when query is empty', () {
    // Act & Assert
    expect(
      () => useCase(''),
      throwsA(isA<ArgumentError>()),
    );
    verifyNever(mockRepository.searchMemories(any, limit: anyNamed('limit')));
  });

  test('should throw ArgumentError when query is only whitespace', () {
    // Act & Assert
    expect(
      () => useCase('   '),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('should use custom limit when provided', () async {
    // Arrange
    when(mockRepository.searchMemories('test query', limit: 5))
        .thenAnswer((_) async => [testSearchResult]);

    // Act
    final result = await useCase('test query', limit: 5);

    // Assert
    verify(mockRepository.searchMemories('test query', limit: 5));
  });

  test('should propagate errors from repository', () async {
    // Arrange
    when(mockRepository.searchMemories('test query', limit: 10))
        .thenThrow(Exception('Repository error'));

    // Act & Assert
    expect(() => useCase('test query'), throwsException);
  });
}

