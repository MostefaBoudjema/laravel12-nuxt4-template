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

import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';

import 'state/settings_controller.dart';

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

class SettingsScope extends InheritedNotifier<SettingsController> {
  const SettingsScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  static SettingsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'SettingsScope not found in widget tree');
    return scope!.notifier!;
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
  late final SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient(baseUrl: AppConfig.apiBaseUrl);
    _authController = AuthController(
      authService: AuthService(apiClient),
      sessionStore: SessionStore(),
    );
    _usersService = UsersService(apiClient);
    _settingsController = SettingsController();
    
    _authController.bootstrap();
    _settingsController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _authController,
      usersService: _usersService,
      child: SettingsScope(
        notifier: _settingsController,
        child: AnimatedBuilder(
          animation: _settingsController,
          builder: (context, _) {
            return MaterialApp(
              title: 'SaaS Mobile',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5), brightness: Brightness.light),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5), brightness: Brightness.dark),
                useMaterial3: true,
              ),
              themeMode: _settingsController.themeMode,
              locale: _settingsController.locale,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English
                Locale('fr', ''), // French
              ],
              home: const SplashPage(),
              routes: {
                '/login': (_) => const LoginPage(),
                '/register': (_) => const RegisterPage(),
                '/dashboard': (_) => const DashboardPage(),
              },
            );
          }
        ),
      ),
    );
  }
}
