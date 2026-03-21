import 'package:flutter/foundation.dart';

import '../core/session_store.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService authService;
  final SessionStore sessionStore;

  AuthController({
    required this.authService,
    required this.sessionStore,
  });

  User? user;
  String? token;
  bool isBootstrapping = true;
  bool isBusy = false;
  String? error;

  bool get isAuthenticated => token != null && user != null;
  bool get isAdmin => user?.roles.contains('admin') ?? false;

  Future<void> bootstrap() async {
    isBootstrapping = true;
    notifyListeners();
    token = await sessionStore.readToken();
    if (token != null && token!.isNotEmpty) {
      try {
        user = await authService.me(token!);
      } catch (_) {
        token = null;
        user = null;
        await sessionStore.clear();
      }
    }
    isBootstrapping = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isBusy = true;
    error = null;
    notifyListeners();
    try {
      final result = await authService.login(email: email, password: password);
      token = result.token;
      user = result.user;
      await sessionStore.saveToken(result.token);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    isBusy = true;
    error = null;
    notifyListeners();
    try {
      await authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final currentToken = token;
    token = null;
    user = null;
    notifyListeners();
    if (currentToken != null) {
      await authService.logout(currentToken);
    }
    await sessionStore.clear();
  }
}
