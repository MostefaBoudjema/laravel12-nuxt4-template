class AppConfig {
  // Pass with: flutter run --dart-define=API_BASE_URL=http://laravel_saas.test/api/v1
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://laravel_saas.test/api/v1',
  );
}
