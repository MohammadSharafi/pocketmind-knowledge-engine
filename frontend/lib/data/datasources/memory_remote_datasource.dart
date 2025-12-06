import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/error/failures.dart';
import '../../graphql/queries.dart';
import '../../graphql/mutations.dart';
import '../models/memory_model.dart';

/// Data source - handles remote data operations
abstract class MemoryRemoteDataSource {
  Future<List<MemoryModel>> getMemories({int? limit, int? offset});
  Future<MemoryModel> getMemoryById(String id);
  Future<MemoryModel> createTextMemory(String content, {String? title});
  Future<void> deleteMemory(String id);
  Future<List<SearchResultModel>> searchMemories(String query, {int limit = 10});
}

class MemoryRemoteDataSourceImpl implements MemoryRemoteDataSource {
  final GraphQLClient client;

  MemoryRemoteDataSourceImpl(this.client);

  @override
  Future<List<MemoryModel>> getMemories({int? limit, int? offset}) async {
    try {
      final result = await client.query(QueryOptions(
        document: gql(GraphQLQueries.getMemories),
        variables: {
          'limit': limit,
          'offset': offset,
        },
      ));

      if (result.hasException) {
        throw ServerFailure(
          result.exception?.graphqlErrors.first.message ?? 'Unknown error',
        );
      }

      final memories = (result.data?['memories'] as List<dynamic>?)
              ?.map((json) => MemoryModel.fromJson(json))
              .toList() ??
          [];

      return memories;
    } catch (e) {
      if (e is Failure) rethrow;
      throw NetworkFailure('Failed to fetch memories: ${e.toString()}');
    }
  }

  @override
  Future<MemoryModel> getMemoryById(String id) async {
    try {
      final result = await client.query(QueryOptions(
        document: gql(GraphQLQueries.getMemory),
        variables: {'id': id},
      ));

      if (result.hasException) {
        throw ServerFailure(
          result.exception?.graphqlErrors.first.message ?? 'Unknown error',
        );
      }

      return MemoryModel.fromJson(result.data!['memory']);
    } catch (e) {
      if (e is Failure) rethrow;
      throw NotFoundFailure('Memory not found: ${e.toString()}');
    }
  }

  @override
  Future<MemoryModel> createTextMemory(String content, {String? title}) async {
    try {
      final result = await client.mutate(MutationOptions(
        document: gql(GraphQLMutations.uploadText),
        variables: {
          'content': content,
          'title': title,
        },
      ));

      if (result.hasException) {
        throw ServerFailure(
          result.exception?.graphqlErrors.first.message ?? 'Unknown error',
        );
      }

      return MemoryModel.fromJson(result.data!['uploadText']);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Failed to create memory: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteMemory(String id) async {
    try {
      final result = await client.mutate(MutationOptions(
        document: gql(GraphQLMutations.deleteMemory),
        variables: {'id': id},
      ));

      if (result.hasException) {
        throw ServerFailure(
          result.exception?.graphqlErrors.first.message ?? 'Unknown error',
        );
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Failed to delete memory: ${e.toString()}');
    }
  }

  @override
  Future<List<SearchResultModel>> searchMemories(String query, {int limit = 10}) async {
    try {
      final result = await client.query(QueryOptions(
        document: gql(GraphQLQueries.search),
        variables: {
          'query': query,
          'limit': limit,
        },
      ));

      if (result.hasException) {
        throw ServerFailure(
          result.exception?.graphqlErrors.first.message ?? 'Unknown error',
        );
      }

      return (result.data?['search'] as List<dynamic>?)
              ?.map((json) => SearchResultModel.fromJson(json))
              .toList() ??
          [];
    } catch (e) {
      if (e is Failure) rethrow;
      throw NetworkFailure('Search failed: ${e.toString()}');
    }
  }
}

