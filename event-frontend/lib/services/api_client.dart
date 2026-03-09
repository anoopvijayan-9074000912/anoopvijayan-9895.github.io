// This file configures a single Dio HTTP client instance
// that the rest of the app can use to talk to the backend API.

import 'package:dio/dio.dart';

class ApiClient {
  // Update this baseUrl if your backend runs on a different host or port.
  static const String baseUrl = 'http://localhost:3000/api';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  static Dio get client => _dio;
}
