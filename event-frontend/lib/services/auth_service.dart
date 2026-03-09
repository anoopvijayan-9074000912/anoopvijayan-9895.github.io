// This service wraps all authentication related API calls
// such as signup and login for both users and admins.

import 'package:dio/dio.dart';
import 'api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.client;

  // Calls the signup API to create a new user account.
  Future<String> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/auth/signup', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    return response.data['token'] as String;
  }

  // Calls the login API. The same endpoint is used for both user and admin.
  Future<({String token, String role, String name})> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final token = response.data['token'] as String;
    final role = response.data['role'] as String;
    final name = response.data['name'] as String;

    return (token: token, role: role, name: name);
  }
}

