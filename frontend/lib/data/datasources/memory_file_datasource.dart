import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/error/failures.dart';
import '../../config/app_config.dart';
import '../models/memory_model.dart';

/// Data source for file uploads (audio, images)
abstract class MemoryFileDataSource {
  Future<MemoryModel> uploadAudio(File file);
  Future<MemoryModel> uploadImage(File file);
}

class MemoryFileDataSourceImpl implements MemoryFileDataSource {
  final Dio dio;

  MemoryFileDataSourceImpl(this.dio);

  @override
  Future<MemoryModel> uploadAudio(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });

      final response = await dio.post(
        '/api/upload/audio',
        data: formData,
      );

      return MemoryModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw ServerFailure(
          e.response?.data?['message'] ?? 'Failed to upload audio',
        );
      }
      throw NetworkFailure('Upload failed: ${e.toString()}');
    }
  }

  @override
  Future<MemoryModel> uploadImage(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });

      final response = await dio.post(
        '/api/upload/image',
        data: formData,
      );

      return MemoryModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw ServerFailure(
          e.response?.data?['message'] ?? 'Failed to upload image',
        );
      }
      throw NetworkFailure('Upload failed: ${e.toString()}');
    }
  }
}

