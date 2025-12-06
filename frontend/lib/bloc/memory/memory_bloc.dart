import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql/queries.dart';
import '../../graphql/mutations.dart';
import '../../models/memory.dart';
import '../../services/api_service.dart';
import 'memory_event.dart';
import 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final GraphQLClient client;
  final ApiService apiService;

  MemoryBloc({required this.client, required this.apiService})
      : super(MemoryInitial()) {
    on<LoadMemories>(_onLoadMemories);
    on<LoadMemory>(_onLoadMemory);
    on<UploadText>(_onUploadText);
    on<UploadAudio>(_onUploadAudio);
    on<UploadImage>(_onUploadImage);
    on<DeleteMemory>(_onDeleteMemory);
    on<MemoryUpdated>(_onMemoryUpdated);
  }

  Future<void> _onLoadMemories(
      LoadMemories event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());

    try {
      final result = await client.query(QueryOptions(
        document: gql(GraphQLQueries.getMemories),
        variables: {
          'limit': event.limit,
          'offset': event.offset,
        },
      ));

      if (result.hasException) {
        emit(MemoryError(result.exception.toString()));
        return;
      }

      final memories = (result.data?['memories'] as List<dynamic>?)
              ?.map((json) => Memory.fromJson(json))
              .toList() ??
          [];

      emit(MemoryLoaded(memories));
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onLoadMemory(
      LoadMemory event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());

    try {
      final result = await client.query(QueryOptions(
        document: gql(GraphQLQueries.getMemory),
        variables: {'id': event.id},
      ));

      if (result.hasException) {
        emit(MemoryError(result.exception.toString()));
        return;
      }

      final memory = Memory.fromJson(result.data!['memory']);
      emit(MemoryLoaded([memory]));
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onUploadText(
      UploadText event, Emitter<MemoryState> emit) async {
    emit(MemoryUploading());

    try {
      final result = await client.mutate(MutationOptions(
        document: gql(GraphQLMutations.uploadText),
        variables: {
          'content': event.content,
          'title': event.title,
        },
      ));

      if (result.hasException) {
        emit(MemoryError(result.exception.toString()));
        return;
      }

      final memory = Memory.fromJson(result.data!['uploadText']);
      emit(MemoryUploaded(memory));
      
      // Reload memories
      add(const LoadMemories());
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onUploadAudio(
      UploadAudio event, Emitter<MemoryState> emit) async {
    emit(MemoryUploading());

    try {
      final file = File(event.filePath);
      final memory = await apiService.uploadAudio(file);
      emit(MemoryUploaded(memory));
      
      // Reload memories
      add(const LoadMemories());
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onUploadImage(
      UploadImage event, Emitter<MemoryState> emit) async {
    emit(MemoryUploading());

    try {
      final file = File(event.filePath);
      final memory = await apiService.uploadImage(file);
      emit(MemoryUploaded(memory));
      
      // Reload memories
      add(const LoadMemories());
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onDeleteMemory(
      DeleteMemory event, Emitter<MemoryState> emit) async {
    try {
      final result = await client.mutate(MutationOptions(
        document: gql(GraphQLMutations.deleteMemory),
        variables: {'id': event.id},
      ));

      if (result.hasException) {
        emit(MemoryError(result.exception.toString()));
        return;
      }

      // Reload memories
      add(const LoadMemories());
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  void _onMemoryUpdated(MemoryUpdated event, Emitter<MemoryState> emit) {
    if (state is MemoryLoaded) {
      final currentMemories = (state as MemoryLoaded).memories;
      final updatedMemories = currentMemories.map((m) {
        return m.id == event.memory.id ? event.memory : m;
      }).toList();
      emit(MemoryLoaded(updatedMemories));
    }
  }
}

