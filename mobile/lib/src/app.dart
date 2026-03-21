import 'package:flutter/material.dart';

import 'core/config.dart';
import 'core/session_store.dart';
import 'screens/dashboard/dashboard_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/splash_page.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/users_service.dart';
import 'state/auth_controller.dart';

class AppScope extends InheritedNotifier<AuthController> {
  final UsersService usersService;

  const AppScope({
    super.key,
    required super.notifier,
    required this.usersService,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!;
  }
}

class SaasMobileApp extends StatefulWidget {
  const SaasMobileApp({super.key});

  @override
  State<SaasMobileApp> createState() => _SaasMobileAppState();
}

class _SaasMobileAppState extends State<SaasMobileApp> {
  late final AuthController _authController;
  late final UsersService _usersService;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient(baseUrl: AppConfig.apiBaseUrl);
    _authController = AuthController(
      authService: AuthService(apiClient),
      sessionStore: SessionStore(),
    );
    _usersService = UsersService(apiClient);
    _authController.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _authController,
      usersService: _usersService,
      child: MaterialApp(
        title: 'SaaS Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
          useMaterial3: true,
        ),
        home: const SplashPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/dashboard': (_) => const DashboardPage(),
        },
      ),
    );
  }
}
