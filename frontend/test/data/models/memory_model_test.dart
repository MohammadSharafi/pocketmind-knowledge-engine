import 'package:flutter_test/flutter_test.dart';
import 'package:pocketmind/data/models/memory_model.dart';
import 'package:pocketmind/domain/entities/memory_entity.dart';

void main() {
  group('MemoryModel', () {
    final testJson = {
      'id': '1',
      'title': 'Test Memory',
      'content': 'Test content',
      'summary': 'Test summary',
      'fileUrl': 'http://example.com/file',
      'fileType': 'TEXT',
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-02T00:00:00.000Z',
      'processingStatus': 'COMPLETED',
      'tags': [
        {
          'id': '1',
          'name': 'Test Tag',
          'color': '#FF0000',
        }
      ],
      'embeddingId': 'emb-1',
    };

    test('fromJson should create MemoryModel from JSON', () {
      final model = MemoryModel.fromJson(testJson);

      expect(model.id, '1');
      expect(model.title, 'Test Memory');
      expect(model.content, 'Test content');
      expect(model.summary, 'Test summary');
      expect(model.fileType, FileTypeEntity.text);
      expect(model.processingStatus, ProcessingStatusEntity.completed);
      expect(model.tags.length, 1);
      expect(model.tags.first.name, 'Test Tag');
    });

    test('fromJson should handle different file types', () {
      final audioJson = {...testJson, 'fileType': 'AUDIO'};
      final audioModel = MemoryModel.fromJson(audioJson);
      expect(audioModel.fileType, FileTypeEntity.audio);

      final imageJson = {...testJson, 'fileType': 'IMAGE'};
      final imageModel = MemoryModel.fromJson(imageJson);
      expect(imageModel.fileType, FileTypeEntity.image);
    });

    test('fromJson should handle different processing statuses', () {
      final pendingJson = {...testJson, 'processingStatus': 'PENDING'};
      final pendingModel = MemoryModel.fromJson(pendingJson);
      expect(pendingModel.processingStatus, ProcessingStatusEntity.pending);

      final processingJson = {...testJson, 'processingStatus': 'PROCESSING'};
      final processingModel = MemoryModel.fromJson(processingJson);
      expect(processingModel.processingStatus, ProcessingStatusEntity.processing);

      final failedJson = {...testJson, 'processingStatus': 'FAILED'};
      final failedModel = MemoryModel.fromJson(failedJson);
      expect(failedModel.processingStatus, ProcessingStatusEntity.failed);
    });

    test('toJson should convert MemoryModel to JSON', () {
      final model = MemoryModel.fromJson(testJson);
      final json = model.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Memory');
      expect(json['fileType'], 'TEXT');
      expect(json['processingStatus'], 'COMPLETED');
    });

    test('toEntity should convert MemoryModel to MemoryEntity', () {
      final model = MemoryModel.fromJson(testJson);
      final entity = model.toEntity();

      expect(entity, isA<MemoryEntity>());
      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.fileType, model.fileType);
    });

    test('fromJson should handle missing optional fields', () {
      final minimalJson = {
        'id': '1',
        'title': 'Test',
        'fileType': 'TEXT',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
        'processingStatus': 'PENDING',
        'tags': [],
      };

      final model = MemoryModel.fromJson(minimalJson);

      expect(model.content, null);
      expect(model.summary, null);
      expect(model.fileUrl, null);
      expect(model.embeddingId, null);
    });
  });

  group('TagModel', () {
    test('fromJson should create TagModel from JSON', () {
      final json = {
        'id': '1',
        'name': 'Test Tag',
        'color': '#FF0000',
      };

      final tag = TagModel.fromJson(json);

      expect(tag.id, '1');
      expect(tag.name, 'Test Tag');
      expect(tag.color, '#FF0000');
    });

    test('toJson should convert TagModel to JSON', () {
      final tag = TagModel(id: '1', name: 'Test Tag', color: '#FF0000');
      final json = tag.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Test Tag');
      expect(json['color'], '#FF0000');
    });
  });

  group('SearchResultModel', () {
    test('fromJson should create SearchResultModel from JSON', () {
      final json = {
        'memory': {
          'id': '1',
          'title': 'Test Memory',
          'fileType': 'TEXT',
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-01-01T00:00:00.000Z',
          'processingStatus': 'COMPLETED',
          'tags': [],
        },
        'score': 0.95,
      };

      final result = SearchResultModel.fromJson(json);

      expect(result.memory.id, '1');
      expect(result.score, 0.95);
    });
  });
}

