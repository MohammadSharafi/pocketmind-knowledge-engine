import 'dart:io';
import 'package:dio/dio.dart';
import '../models/memory.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<Memory> uploadAudio(File audioFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(audioFile.path),
    });

    final response = await _dio.post(
      '/api/upload/audio',
      data: formData,
    );

    return Memory.fromJson(response.data);
  }

  Future<Memory> uploadImage(File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
    });

    final response = await _dio.post(
      '/api/upload/image',
      data: formData,
    );

    return Memory.fromJson(response.data);
  }
}

