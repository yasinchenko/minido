// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minido/data/services/auth_service.dart';
import 'package:minido/data/models/user_model.dart';

class UserModel {
  final int? id;
  final String? email;
  final String? token;

  UserModel({this.id, this.email, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      token: json['access_token'],
    );
  }
}



final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthController(service);
});

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;
  AuthController(this._authService) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.login(username, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.register(username, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}