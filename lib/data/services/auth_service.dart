// lib/data/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const _baseUrl = 'http://194.87.145.25';

  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=$username&password=$password',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = UserModel(token: data['access_token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token ?? '');
      return user;
    } else {
      throw Exception('Ошибка входа');
    }
  }

  Future<UserModel> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = UserModel(email: data['email'], id: data['id']);
      return user;
    } else {
      throw Exception('Ошибка регистрации');
    }
  }
}
