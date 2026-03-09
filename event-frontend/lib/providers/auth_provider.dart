// This provider holds authentication state (token, role, name)
// and exposes helper methods to log in and sign up.

import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  String? _role;
  String? _name;

  String? get token => _token;
  String? get role => _role;
  String? get name => _name;

  bool get isLoggedIn => _token != null;
  bool get isAdmin => _role == 'admin';

  // Logs in the user or admin and stores the returned token.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(email: email, password: password);
    _token = result.token;
    _role = result.role;
    _name = result.name;
    ApiClient.setAuthToken(_token);
    notifyListeners();
  }

  // Signs up a new user and stores the token.
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final token = await _authService.signup(
      name: name,
      email: email,
      password: password,
    );
    _token = token;
    _role = 'user';
    _name = name;
    ApiClient.setAuthToken(_token);
    notifyListeners();
  }

  // Clears all authentication-related state.
  void logout() {
    _token = null;
    _role = null;
    _name = null;
    ApiClient.setAuthToken(null);
    notifyListeners();
  }
}

