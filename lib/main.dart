import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mawidak/config/di/injection.dart';
import 'package:mawidak/config/router/app_router.dart';
import 'package:mawidak/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await configureDependencies();

  runApp(const ProviderScope(child: MawidakApp()));
}

class MawidakApp extends StatelessWidget {
  const MawidakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'موعدك',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}
