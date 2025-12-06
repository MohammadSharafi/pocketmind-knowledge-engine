import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pocketmind/domain/entities/memory_entity.dart';
import 'package:pocketmind/domain/repositories/memory_repository.dart';
import 'package:pocketmind/domain/usecases/get_memories_usecase.dart';

import 'get_memories_usecase_test.mocks.dart';

@GenerateMocks([MemoryRepository])
void main() {
  late GetMemoriesUseCase useCase;
  late MockMemoryRepository mockRepository;

  setUp(() {
    mockRepository = MockMemoryRepository();
    useCase = GetMemoriesUseCase(mockRepository);
  });

  final testMemories = [
    MemoryEntity(
      id: '1',
      title: 'Memory 1',
      fileType: FileTypeEntity.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      processingStatus: ProcessingStatusEntity.completed,
      tags: [],
    ),
    MemoryEntity(
      id: '2',
      title: 'Memory 2',
      fileType: FileTypeEntity.audio,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      processingStatus: ProcessingStatusEntity.processing,
      tags: [],
    ),
  ];

  test('should get memories from repository', () async {
    // Arrange
    when(mockRepository.getMemories(limit: null, offset: null))
        .thenAnswer((_) async => testMemories);

    // Act
    final result = await useCase();

    // Assert
    expect(result, testMemories);
    verify(mockRepository.getMemories(limit: null, offset: null));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should get memories with limit and offset', () async {
    // Arrange
    when(mockRepository.getMemories(limit: 10, offset: 0))
        .thenAnswer((_) async => testMemories);

    // Act
    final result = await useCase(limit: 10, offset: 0);

    // Assert
    expect(result, testMemories);
    verify(mockRepository.getMemories(limit: 10, offset: 0));
  });

  test('should propagate errors from repository', () async {
    // Arrange
    when(mockRepository.getMemories(limit: null, offset: null))
        .thenThrow(Exception('Repository error'));

    // Act & Assert
    expect(() => useCase(), throwsException);
    verify(mockRepository.getMemories(limit: null, offset: null));
  });
}

