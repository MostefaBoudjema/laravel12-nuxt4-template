import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Settings page (port from frontend/app/pages/dashboard/settings.vue)',
        textAlign: TextAlign.center,
      ),
    );
  }
}
