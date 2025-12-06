import 'package:equatable/equatable.dart';
import '../../../domain/entities/memory_entity.dart';
import '../../../core/error/failures.dart';

abstract class MemoryState extends Equatable {
  const MemoryState();

  @override
  List<Object?> get props => [];
}

class MemoryInitial extends MemoryState {}

class MemoryLoading extends MemoryState {}

class MemoryLoaded extends MemoryState {
  final List<MemoryEntity> memories;

  const MemoryLoaded(this.memories);

  @override
  List<Object?> get props => [memories];
}

class MemoryError extends MemoryState {
  final Failure failure;

  const MemoryError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class MemoryUploading extends MemoryState {}

class MemoryUploaded extends MemoryState {
  final MemoryEntity memory;

  const MemoryUploaded(this.memory);

  @override
  List<Object?> get props => [memory];
}

