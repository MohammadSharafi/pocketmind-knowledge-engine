import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pocketmind/data/datasources/memory_remote_datasource.dart';
import 'package:pocketmind/data/models/memory_model.dart';
import 'package:pocketmind/core/error/failures.dart';

import 'memory_remote_datasource_test.mocks.dart';

@GenerateMocks([GraphQLClient])
void main() {
  late MemoryRemoteDataSourceImpl dataSource;
  late MockGraphQLClient mockClient;

  setUp(() {
    mockClient = MockGraphQLClient();
    dataSource = MemoryRemoteDataSourceImpl(mockClient);
  });

  final testMemoryJson = {
    'id': '1',
    'title': 'Test Memory',
    'content': 'Test content',
    'summary': 'Test summary',
    'fileUrl': 'http://example.com/file',
    'fileType': 'TEXT',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
    'processingStatus': 'COMPLETED',
    'tags': [],
    'embeddingId': 'emb-1',
  };

  group('getMemories', () {
    test('should return list of MemoryModel when query is successful', () async {
      // Arrange
      final queryResult = QueryResult(
        options: QueryOptions(document: gql('')),
        data: {
          'memories': [testMemoryJson]
        },
      );

      when(mockClient.query(any)).thenAnswer((_) async => queryResult);

      // Act
      final result = await dataSource.getMemories();

      // Assert
      expect(result, isA<List<MemoryModel>>());
      expect(result.length, 1);
      expect(result.first.id, '1');
      expect(result.first.title, 'Test Memory');
    });

    test('should throw ServerFailure when query has exception', () async {
      // Arrange
      final queryResult = QueryResult(
        options: QueryOptions(document: gql('')),
        exception: OperationException(
          graphqlErrors: [GraphQLError(message: 'Server error')],
        ),
      );

      when(mockClient.query(any)).thenAnswer((_) async => queryResult);

      // Act & Assert
      expect(
        () => dataSource.getMemories(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('should throw NetworkFailure on general exception', () async {
      // Arrange
      when(mockClient.query(any)).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => dataSource.getMemories(),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  group('getMemoryById', () {
    test('should return MemoryModel when query is successful', () async {
      // Arrange
      final queryResult = QueryResult(
        options: QueryOptions(document: gql('')),
        data: {'memory': testMemoryJson},
      );

      when(mockClient.query(any)).thenAnswer((_) async => queryResult);

      // Act
      final result = await dataSource.getMemoryById('1');

      // Assert
      expect(result, isA<MemoryModel>());
      expect(result.id, '1');
      expect(result.title, 'Test Memory');
    });

    test('should throw NotFoundFailure when memory not found', () async {
      // Arrange
      final queryResult = QueryResult(
        options: QueryOptions(document: gql('')),
        exception: OperationException(
          graphqlErrors: [GraphQLError(message: 'Not found')],
        ),
      );

      when(mockClient.query(any)).thenAnswer((_) async => queryResult);

      // Act & Assert
      expect(
        () => dataSource.getMemoryById('1'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  group('createTextMemory', () {
    test('should return MemoryModel when mutation is successful', () async {
      // Arrange
      final mutationResult = QueryResult(
        options: QueryOptions(document: gql('')),
        data: {'uploadText': testMemoryJson},
      );

      when(mockClient.mutate(any)).thenAnswer((_) async => mutationResult);

      // Act
      final result = await dataSource.createTextMemory('Test content');

      // Assert
      expect(result, isA<MemoryModel>());
      expect(result.content, 'Test content');
    });

    test('should throw ServerFailure when mutation fails', () async {
      // Arrange
      final mutationResult = QueryResult(
        options: QueryOptions(document: gql('')),
        exception: OperationException(
          graphqlErrors: [GraphQLError(message: 'Mutation failed')],
        ),
      );

      when(mockClient.mutate(any)).thenAnswer((_) async => mutationResult);

      // Act & Assert
      expect(
        () => dataSource.createTextMemory('Test content'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  group('searchMemories', () {
    test('should return list of SearchResultModel when search is successful', () async {
      // Arrange
      final queryResult = QueryResult(
        options: QueryOptions(document: gql('')),
        data: {
          'search': [
            {
              'memory': testMemoryJson,
              'score': 0.95,
            }
          ]
        },
      );

      when(mockClient.query(any)).thenAnswer((_) async => queryResult);

      // Act
      final result = await dataSource.searchMemories('test query');

      // Assert
      expect(result, isA<List>());
      expect(result.length, 1);
      expect(result.first.memory.id, '1');
      expect(result.first.score, 0.95);
    });
  });
}

