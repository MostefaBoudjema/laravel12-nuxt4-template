import '../models/user.dart';
import 'api_client.dart';

class LoginResult {
  final String token;
  final User user;

  const LoginResult({required this.token, required this.user});
}

class AuthService {
  final ApiClient api;

  const AuthService(this.api);

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final json = await api.postJson('/login', body: {
      'email': email,
      'password': password,
    });
    final data = (json['data'] as Map<String, dynamic>? ?? <String, dynamic>{});
    return LoginResult(
      token: data['token'] as String? ?? '',
      user: User.fromJson((data['user'] as Map<String, dynamic>? ?? <String, dynamic>{})),
    );
    }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    await api.postJson('/register', body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  Future<User> me(String token) async {
    final json = await api.getJson('/me', token: token);
    final data = (json['data'] as Map<String, dynamic>? ?? <String, dynamic>{});
    return User.fromJson((data['user'] as Map<String, dynamic>? ?? <String, dynamic>{}));
  }

  Future<void> logout(String token) async {
    try {
      await api.postJson('/logout', body: {}, token: token);
    } catch (_) {
      // Keep logout best-effort to match frontend behavior.
    }
  }
}
