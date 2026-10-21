import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class SericultureApp extends StatelessWidget {
  const SericultureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sericulture',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
