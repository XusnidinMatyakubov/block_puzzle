import 'package:flutter/material.dart';

import 'screens/game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

class BlockPuzzleApp extends StatelessWidget {
  const BlockPuzzleApp({
    required this.storageService,
    super.key,
  });

  final StorageService storageService;

  static const splashRoute = '/';
  static const homeRoute = '/home';
  static const gameRoute = '/game';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Puzzle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: splashRoute,
      routes: {
        splashRoute: (_) => const SplashScreen(),
        homeRoute: (_) => HomeScreen(storageService: storageService),
        gameRoute: (_) => GameScreen(storageService: storageService),
      },
    );
  }
}
