import '../entities/memory_entity.dart';
import '../repositories/memory_repository.dart';
import 'dart:io';

class UploadAudioUseCase {
  final MemoryRepository repository;

  UploadAudioUseCase(this.repository);

  Future<MemoryEntity> call(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException('Audio file not found', filePath);
    }
    return repository.uploadAudio(filePath);
  }
}

