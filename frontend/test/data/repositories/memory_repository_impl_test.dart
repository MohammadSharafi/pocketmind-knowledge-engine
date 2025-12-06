import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pocketmind/data/repositories/memory_repository_impl.dart';
import 'package:pocketmind/data/datasources/memory_remote_datasource.dart';
import 'package:pocketmind/data/datasources/memory_file_datasource.dart';
import 'package:pocketmind/data/models/memory_model.dart';
import 'package:pocketmind/domain/entities/memory_entity.dart';

import 'memory_repository_impl_test.mocks.dart';

@GenerateMocks([MemoryRemoteDataSource, MemoryFileDataSource])
void main() {
  late MemoryRepositoryImpl repository;
  late MockMemoryRemoteDataSource mockRemoteDataSource;
  late MockMemoryFileDataSource mockFileDataSource;

  setUp(() {
    mockRemoteDataSource = MockMemoryRemoteDataSource();
    mockFileDataSource = MockMemoryFileDataSource();
    repository = MemoryRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      fileDataSource: mockFileDataSource,
    );
  });

  final testMemoryModel = MemoryModel(
    id: '1',
    title: 'Test Memory',
    content: 'Test content',
    fileType: FileTypeEntity.text,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    processingStatus: ProcessingStatusEntity.completed,
    tags: [],
  );

  group('getMemories', () {
    test('should return list of MemoryEntity from remote data source', () async {
      // Arrange
      when(mockRemoteDataSource.getMemories(limit: null, offset: null))
          .thenAnswer((_) async => [testMemoryModel]);

      // Act
      final result = await repository.getMemories();

      // Assert
      expect(result, isA<List<MemoryEntity>>());
      expect(result.length, 1);
      expect(result.first.id, '1');
      verify(mockRemoteDataSource.getMemories(limit: null, offset: null));
    });
  });

  group('getMemoryById', () {
    test('should return MemoryEntity from remote data source', () async {
      // Arrange
      when(mockRemoteDataSource.getMemoryById('1'))
          .thenAnswer((_) async => testMemoryModel);

      // Act
      final result = await repository.getMemoryById('1');

      // Assert
      expect(result, isA<MemoryEntity>());
      expect(result.id, '1');
      verify(mockRemoteDataSource.getMemoryById('1'));
    });
  });

  group('createTextMemory', () {
    test('should return MemoryEntity after creating text memory', () async {
      // Arrange
      when(mockRemoteDataSource.createTextMemory('Test content', title: null))
          .thenAnswer((_) async => testMemoryModel);

      // Act
      final result = await repository.createTextMemory('Test content');

      // Assert
      expect(result, isA<MemoryEntity>());
      expect(result.content, 'Test content');
      verify(mockRemoteDataSource.createTextMemory('Test content', title: null));
    });
  });

  group('uploadAudio', () {
    test('should return MemoryEntity after uploading audio', () async {
      // Arrange
      final audioModel = MemoryModel(
        id: '2',
        title: 'Audio Memory',
        fileType: FileTypeEntity.audio,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        processingStatus: ProcessingStatusEntity.pending,
        tags: [],
      );

      when(mockFileDataSource.uploadAudio(any))
          .thenAnswer((_) async => audioModel);

      // Act
      final result = await repository.uploadAudio('test_audio.m4a');

      // Assert
      expect(result, isA<MemoryEntity>());
      expect(result.fileType, FileTypeEntity.audio);
      verify(mockFileDataSource.uploadAudio(any));
    });
  });

  group('uploadImage', () {
    test('should return MemoryEntity after uploading image', () async {
      // Arrange
      final imageModel = MemoryModel(
        id: '3',
        title: 'Image Memory',
        fileType: FileTypeEntity.image,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        processingStatus: ProcessingStatusEntity.pending,
        tags: [],
      );

      when(mockFileDataSource.uploadImage(any))
          .thenAnswer((_) async => imageModel);

      // Act
      final result = await repository.uploadImage('test_image.jpg');

      // Assert
      expect(result, isA<MemoryEntity>());
      expect(result.fileType, FileTypeEntity.image);
      verify(mockFileDataSource.uploadImage(any));
    });
  });

  group('deleteMemory', () {
    test('should delete memory successfully', () async {
      // Arrange
      when(mockRemoteDataSource.deleteMemory('1'))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.deleteMemory('1');

      // Assert
      verify(mockRemoteDataSource.deleteMemory('1'));
    });
  });
}

