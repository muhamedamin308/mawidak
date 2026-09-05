class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const adminDashboard = '/admin';
  static const staffSchedule = '/staff';
  static const services = '/admin/services';
  static const serviceForm = '/admin/services/form';
  static const staff = '/admin/staff';
  static const staffForm = '/admin/staff/form';
  static const workingHours =
      '/admin/staff/:staffId/hours'; // ← must match exactly
}
