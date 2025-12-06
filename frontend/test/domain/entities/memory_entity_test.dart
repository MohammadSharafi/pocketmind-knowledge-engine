import 'package:flutter_test/flutter_test.dart';
import 'package:pocketmind/domain/entities/memory_entity.dart';

void main() {
  group('MemoryEntity', () {
    final testMemory = MemoryEntity(
      id: '1',
      title: 'Test Memory',
      content: 'Test content',
      summary: 'Test summary',
      fileUrl: 'http://example.com/file',
      fileType: FileTypeEntity.text,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
      processingStatus: ProcessingStatusEntity.completed,
      tags: [],
      embeddingId: 'emb-1',
    );

    test('should create a valid MemoryEntity', () {
      expect(testMemory.id, '1');
      expect(testMemory.title, 'Test Memory');
      expect(testMemory.content, 'Test content');
      expect(testMemory.summary, 'Test summary');
      expect(testMemory.fileType, FileTypeEntity.text);
      expect(testMemory.processingStatus, ProcessingStatusEntity.completed);
    });

    test('isProcessed should return true when status is completed', () {
      expect(testMemory.isProcessed, true);
      
      final pendingMemory = testMemory.copyWith(
        processingStatus: ProcessingStatusEntity.pending,
      );
      expect(pendingMemory.isProcessed, false);
    });

    test('isProcessing should return true when status is processing', () {
      final processingMemory = testMemory.copyWith(
        processingStatus: ProcessingStatusEntity.processing,
      );
      expect(processingMemory.isProcessing, true);
      expect(testMemory.isProcessing, false);
    });

    test('hasFailed should return true when status is failed', () {
      final failedMemory = testMemory.copyWith(
        processingStatus: ProcessingStatusEntity.failed,
      );
      expect(failedMemory.hasFailed, true);
      expect(testMemory.hasFailed, false);
    });

    test('copyWith should create a new instance with updated fields', () {
      final updated = testMemory.copyWith(
        title: 'Updated Title',
        content: 'Updated content',
      );

      expect(updated.title, 'Updated Title');
      expect(updated.content, 'Updated content');
      expect(updated.id, testMemory.id); // Unchanged
      expect(updated.summary, testMemory.summary); // Unchanged
    });
  });

  group('FileTypeEntity', () {
    test('displayName should return correct string for each type', () {
      expect(FileTypeEntity.audio.displayName, 'Audio');
      expect(FileTypeEntity.image.displayName, 'Image');
      expect(FileTypeEntity.text.displayName, 'Text');
    });
  });

  group('ProcessingStatusEntity', () {
    test('displayName should return correct string for each status', () {
      expect(ProcessingStatusEntity.pending.displayName, 'Pending');
      expect(ProcessingStatusEntity.processing.displayName, 'Processing');
      expect(ProcessingStatusEntity.completed.displayName, 'Completed');
      expect(ProcessingStatusEntity.failed.displayName, 'Failed');
    });
  });

  group('TagEntity', () {
    test('should create a valid TagEntity', () {
      final tag = TagEntity(
        id: '1',
        name: 'Test Tag',
        color: '#FF0000',
      );

      expect(tag.id, '1');
      expect(tag.name, 'Test Tag');
      expect(tag.color, '#FF0000');
    });

    test('should create TagEntity without color', () {
      final tag = TagEntity(
        id: '1',
        name: 'Test Tag',
      );

      expect(tag.color, null);
    });
  });
}

