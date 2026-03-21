// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'System Users';

  @override
  String get manageUsers => 'Manage users';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get addUser => 'Add User';

  @override
  String get noUsersFound => 'No users found.';

  @override
  String get refresh => 'Refresh';

  @override
  String get deleteUser => 'Delete user';

  @override
  String deleteConfirm(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get userDeletedSuccess => 'User deleted successfully';

  @override
  String get themeLight => 'Light Theme';

  @override
  String get themeDark => 'Dark Theme';

  @override
  String get themeSystem => 'System Theme';
}
