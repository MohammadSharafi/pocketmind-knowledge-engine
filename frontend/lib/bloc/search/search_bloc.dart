import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql/queries.dart';
import '../../models/memory.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GraphQLClient client;

  SearchBloc({required this.client}) : super(SearchInitial()) {
    on<PerformSearch>(_onPerformSearch);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onPerformSearch(
      PerformSearch event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    try {
      final result = await client.query(QueryOptions(
        document: gql(GraphQLQueries.search),
        variables: {
          'query': event.query,
          'limit': event.limit ?? 10,
        },
      ));

      if (result.hasException) {
        emit(SearchError(result.exception.toString()));
        return;
      }

      final results = (result.data?['search'] as List<dynamic>?)
              ?.map((json) => SearchResult.fromJson(json))
              .toList() ??
          [];

      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}

