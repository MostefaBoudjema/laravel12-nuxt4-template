import 'package:flutter/material.dart';

import '../app.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = AppScope.of(context).notifier!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || auth.isBootstrapping) return;
      Navigator.of(context).pushReplacementNamed(
        auth.isAuthenticated ? '/dashboard' : '/login',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = AppScope.of(context).notifier!;
    if (!auth.isBootstrapping) {
      return const SizedBox.shrink();
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
