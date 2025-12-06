import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearch extends SearchEvent {
  final String query;
  final int? limit;

  const PerformSearch({required this.query, this.limit});

  @override
  List<Object?> get props => [query, limit];
}

class ClearSearch extends SearchEvent {}

