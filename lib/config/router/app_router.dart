import 'package:go_router/go_router.dart';
import 'package:mawidak/config/router/app_routes.dart';
import 'package:mawidak/features/splash/presentation/pages/splash_page.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
  ],
);
