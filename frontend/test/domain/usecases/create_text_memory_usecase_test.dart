import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pocketmind/domain/entities/memory_entity.dart';
import 'package:pocketmind/domain/repositories/memory_repository.dart';
import 'package:pocketmind/domain/usecases/create_text_memory_usecase.dart';

import 'create_text_memory_usecase_test.mocks.dart';

@GenerateMocks([MemoryRepository])
void main() {
  late CreateTextMemoryUseCase useCase;
  late MockMemoryRepository mockRepository;

  setUp(() {
    mockRepository = MockMemoryRepository();
    useCase = CreateTextMemoryUseCase(mockRepository);
  });

  final testMemory = MemoryEntity(
    id: '1',
    title: 'Test Memory',
    content: 'Test content',
    fileType: FileTypeEntity.text,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    processingStatus: ProcessingStatusEntity.pending,
    tags: [],
  );

  test('should create text memory successfully', () async {
    // Arrange
    when(mockRepository.createTextMemory('Test content', title: null))
        .thenAnswer((_) async => testMemory);

    // Act
    final result = await useCase('Test content');

    // Assert
    expect(result, testMemory);
    verify(mockRepository.createTextMemory('Test content', title: null));
  });

  test('should create text memory with title', () async {
    // Arrange
    when(mockRepository.createTextMemory('Test content', title: 'My Title'))
        .thenAnswer((_) async => testMemory);

    // Act
    final result = await useCase('Test content', title: 'My Title');

    // Assert
    expect(result, testMemory);
    verify(mockRepository.createTextMemory('Test content', title: 'My Title'));
  });

  test('should throw ArgumentError when content is empty', () {
    // Act & Assert
    expect(
      () => useCase(''),
      throwsA(isA<ArgumentError>()),
    );
    verifyNever(mockRepository.createTextMemory(any, title: anyNamed('title')));
  });

  test('should throw ArgumentError when content is only whitespace', () {
    // Act & Assert
    expect(
      () => useCase('   '),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('should propagate errors from repository', () async {
    // Arrange
    when(mockRepository.createTextMemory('Test content', title: null))
        .thenThrow(Exception('Repository error'));

    // Act & Assert
    expect(() => useCase('Test content'), throwsException);
  });
}

