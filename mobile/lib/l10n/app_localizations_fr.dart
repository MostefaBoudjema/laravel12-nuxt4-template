// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Utilisateurs système';

  @override
  String get manageUsers => 'Gérer les utilisateurs';

  @override
  String get searchUsers => 'Rechercher des utilisateurs...';

  @override
  String get addUser => 'Ajouter un utilisateur';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé.';

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get deleteUser => 'Supprimer l\'utilisateur';

  @override
  String deleteConfirm(String name) {
    return 'Êtes-vous sûr de vouloir supprimer $name?';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get userDeletedSuccess => 'Utilisateur supprimé avec succès';

  @override
  String get themeLight => 'Thème Clair';

  @override
  String get themeDark => 'Thème Sombre';

  @override
  String get themeSystem => 'Thème Système';
}
