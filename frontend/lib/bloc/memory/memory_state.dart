import 'package:equatable/equatable.dart';
import '../../models/memory.dart';

abstract class MemoryState extends Equatable {
  const MemoryState();

  @override
  List<Object?> get props => [];
}

class MemoryInitial extends MemoryState {}

class MemoryLoading extends MemoryState {}

class MemoryLoaded extends MemoryState {
  final List<Memory> memories;

  const MemoryLoaded(this.memories);

  @override
  List<Object?> get props => [memories];
}

class MemoryError extends MemoryState {
  final String message;

  const MemoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class MemoryUploading extends MemoryState {}

class MemoryUploaded extends MemoryState {
  final Memory memory;

  const MemoryUploaded(this.memory);

  @override
  List<Object?> get props => [memory];
}

