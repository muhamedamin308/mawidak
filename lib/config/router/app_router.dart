import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mawidak/config/router/app_routes.dart';
import 'package:mawidak/features/auth/presentation/pages/login_page.dart';
import 'package:mawidak/features/busniess/domain/entities/service_entity.dart';
import 'package:mawidak/features/busniess/domain/entities/staff_entity.dart';
import 'package:mawidak/features/busniess/presentation/pages/admin_dashboard_page.dart';
import 'package:mawidak/features/busniess/presentation/pages/customer_home_page.dart';
import 'package:mawidak/features/busniess/presentation/pages/services_page.dart';
import 'package:mawidak/features/busniess/presentation/pages/services_page_form.dart';
import 'package:mawidak/features/busniess/presentation/pages/staff_form_page.dart';
import 'package:mawidak/features/busniess/presentation/pages/staff_page.dart';
import 'package:mawidak/features/busniess/presentation/pages/working_hours_page.dart';
import 'package:mawidak/features/splash/presentation/pages/splash_page.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
    GoRoute(path: AppRoutes.home, builder: (_, __) => const CustomerHomePage()),
    GoRoute(
      path: AppRoutes.adminDashboard,
      builder: (_, __) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.staffSchedule,
      builder: (_, __) => const Placeholder(),
    ),
    GoRoute(path: AppRoutes.services, builder: (_, __) => const ServicesPage()),
    GoRoute(
      path: AppRoutes.serviceForm,
      builder: (_, state) =>
          ServiceFormPage(existing: state.extra as ServiceEntity?),
    ),
    GoRoute(path: AppRoutes.staff, builder: (_, __) => const StaffPage()),
    GoRoute(
      path: AppRoutes.staffForm,
      builder: (_, state) =>
          StaffFormPage(existing: state.extra as StaffEntity?),
    ),
    GoRoute(
      path: '/admin/staff/:staffId/hours',
      name: 'workingHours',
      builder: (_, state) => WorkingHoursPage(
        staffId: int.parse(state.pathParameters['staffId']!),
      ),
    ),
  ],
);
