import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pocketmind/domain/entities/memory_entity.dart';
import 'package:pocketmind/domain/repositories/memory_repository.dart';
import 'package:pocketmind/domain/usecases/upload_audio_usecase.dart';

import 'upload_audio_usecase_test.mocks.dart';

@GenerateMocks([MemoryRepository])
void main() {
  late UploadAudioUseCase useCase;
  late MockMemoryRepository mockRepository;

  setUp(() {
    mockRepository = MockMemoryRepository();
    useCase = UploadAudioUseCase(mockRepository);
  });

  final testMemory = MemoryEntity(
    id: '1',
    title: 'Audio Memory',
    fileType: FileTypeEntity.audio,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    processingStatus: ProcessingStatusEntity.pending,
    tags: [],
  );

  test('should upload audio successfully', () async {
    // Arrange
    final testFile = File('test_audio.m4a');
    when(mockRepository.uploadAudio('test_audio.m4a'))
        .thenAnswer((_) async => testMemory);

    // Act
    final result = await useCase('test_audio.m4a');

    // Assert
    expect(result, testMemory);
    verify(mockRepository.uploadAudio('test_audio.m4a'));
  });

  test('should throw FileSystemException when file does not exist', () {
    // Arrange
    final nonExistentFile = 'non_existent.m4a';

    // Act & Assert
    expect(
      () => useCase(nonExistentFile),
      throwsA(isA<FileSystemException>()),
    );
    verifyNever(mockRepository.uploadAudio(any));
  });

  test('should propagate errors from repository', () async {
    // Arrange
    final testFile = File('test_audio.m4a');
    when(mockRepository.uploadAudio('test_audio.m4a'))
        .thenThrow(Exception('Repository error'));

    // Act & Assert
    expect(() => useCase('test_audio.m4a'), throwsException);
  });
}

