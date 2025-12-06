import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_memories_usecase.dart';
import '../../../domain/usecases/create_text_memory_usecase.dart';
import '../../../domain/usecases/upload_audio_usecase.dart';
import '../../../domain/usecases/search_memories_usecase.dart';
import '../../../core/error/failures.dart';
import 'memory_event.dart';
import 'memory_state.dart';

/// BLoC - Presentation layer, uses use cases from domain layer
class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final GetMemoriesUseCase getMemoriesUseCase;
  final CreateTextMemoryUseCase createTextMemoryUseCase;
  final UploadAudioUseCase uploadAudioUseCase;
  final SearchMemoriesUseCase searchMemoriesUseCase;

  MemoryBloc({
    required this.getMemoriesUseCase,
    required this.createTextMemoryUseCase,
    required this.uploadAudioUseCase,
    required this.searchMemoriesUseCase,
  }) : super(MemoryInitial()) {
    on<LoadMemoriesEvent>(_onLoadMemories);
    on<CreateTextMemoryEvent>(_onCreateTextMemory);
    on<UploadAudioEvent>(_onUploadAudio);
    on<UploadImageEvent>(_onUploadImage);
    on<DeleteMemoryEvent>(_onDeleteMemory);
    on<MemoryUpdatedEvent>(_onMemoryUpdated);
  }

  Future<void> _onLoadMemories(
      LoadMemoriesEvent event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());

    try {
      final memories = await getMemoriesUseCase(
        limit: event.limit,
        offset: event.offset,
      );
      emit(MemoryLoaded(memories));
    } on Failure catch (failure) {
      emit(MemoryError(failure));
    } catch (e) {
      emit(MemoryError(ServerFailure(e.toString())));
    }
  }

  Future<void> _onCreateTextMemory(
      CreateTextMemoryEvent event, Emitter<MemoryState> emit) async {
    emit(MemoryUploading());

    try {
      final memory = await createTextMemoryUseCase(
        event.content,
        title: event.title,
      );
      emit(MemoryUploaded(memory));
      add(const LoadMemoriesEvent());
    } on Failure catch (failure) {
      emit(MemoryError(failure));
    } catch (e) {
      emit(MemoryError(ServerFailure(e.toString())));
    }
  }

  Future<void> _onUploadAudio(
      UploadAudioEvent event, Emitter<MemoryState> emit) async {
    emit(MemoryUploading());

    try {
      final memory = await uploadAudioUseCase(event.filePath);
      emit(MemoryUploaded(memory));
      add(const LoadMemoriesEvent());
    } on Failure catch (failure) {
      emit(MemoryError(failure));
    } catch (e) {
      emit(MemoryError(ServerFailure(e.toString())));
    }
  }

  Future<void> _onUploadImage(
      UploadImageEvent event, Emitter<MemoryState> emit) async {
    emit(MemoryUploading());

    try {
      // Similar to audio upload - would need UploadImageUseCase
      add(const LoadMemoriesEvent());
    } on Failure catch (failure) {
      emit(MemoryError(failure));
    } catch (e) {
      emit(MemoryError(ServerFailure(e.toString())));
    }
  }

  Future<void> _onDeleteMemory(
      DeleteMemoryEvent event, Emitter<MemoryState> emit) async {
    try {
      // Would need DeleteMemoryUseCase
      add(const LoadMemoriesEvent());
    } on Failure catch (failure) {
      emit(MemoryError(failure));
    } catch (e) {
      emit(MemoryError(ServerFailure(e.toString())));
    }
  }

  void _onMemoryUpdated(MemoryUpdatedEvent event, Emitter<MemoryState> emit) {
    if (state is MemoryLoaded) {
      final currentMemories = (state as MemoryLoaded).memories;
      final updatedMemories = currentMemories.map((m) {
        return m.id == event.memory.id ? event.memory : m;
      }).toList();
      emit(MemoryLoaded(updatedMemories));
    }
  }
}

