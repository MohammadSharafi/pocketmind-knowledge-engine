import 'package:equatable/equatable.dart';
import '../../../domain/entities/memory_entity.dart';

abstract class MemoryEvent extends Equatable {
  const MemoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadMemoriesEvent extends MemoryEvent {
  final int? limit;
  final int? offset;

  const LoadMemoriesEvent({this.limit, this.offset});

  @override
  List<Object?> get props => [limit, offset];
}

class LoadMemoryEvent extends MemoryEvent {
  final String id;

  const LoadMemoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateTextMemoryEvent extends MemoryEvent {
  final String content;
  final String? title;

  const CreateTextMemoryEvent({required this.content, this.title});

  @override
  List<Object?> get props => [content, title];
}

class UploadAudioEvent extends MemoryEvent {
  final String filePath;

  const UploadAudioEvent(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class UploadImageEvent extends MemoryEvent {
  final String filePath;

  const UploadImageEvent(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class DeleteMemoryEvent extends MemoryEvent {
  final String id;

  const DeleteMemoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MemoryUpdatedEvent extends MemoryEvent {
  final MemoryEntity memory;

  const MemoryUpdatedEvent(this.memory);

  @override
  List<Object?> get props => [memory];
}

