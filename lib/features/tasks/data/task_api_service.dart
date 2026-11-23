import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../domain/task.dart';

class TaskApiService {
  TaskApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://jsonplaceholder.typicode.com',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  static const int userId = 2;

  final Dio _dio;

  Future<List<Task>> getTasks() async {
    final response = await _dio.get<List<dynamic>>(
      '/todos',
      queryParameters: {'userId': userId},
    );
    debugPrint('GET /todos?userId=$userId → HTTP ${response.statusCode}');

    final data = response.data;
    if (data == null) {
      throw const FormatException('La API no devolvió tareas.');
    }

    return data
        .map((item) => Task.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
