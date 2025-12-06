import 'package:equatable/equatable.dart';
import '../../models/memory.dart';

abstract class MemoryEvent extends Equatable {
  const MemoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadMemories extends MemoryEvent {
  final int? limit;
  final int? offset;

  const LoadMemories({this.limit, this.offset});

  @override
  List<Object?> get props => [limit, offset];
}

class LoadMemory extends MemoryEvent {
  final String id;

  const LoadMemory(this.id);

  @override
  List<Object?> get props => [id];
}

class UploadText extends MemoryEvent {
  final String content;
  final String? title;

  const UploadText({required this.content, this.title});

  @override
  List<Object?> get props => [content, title];
}

class UploadAudio extends MemoryEvent {
  final String filePath;

  const UploadAudio(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class UploadImage extends MemoryEvent {
  final String filePath;

  const UploadImage(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class DeleteMemory extends MemoryEvent {
  final String id;

  const DeleteMemory(this.id);

  @override
  List<Object?> get props => [id];
}

class MemoryUpdated extends MemoryEvent {
  final Memory memory;

  const MemoryUpdated(this.memory);

  @override
  List<Object?> get props => [memory];
}

