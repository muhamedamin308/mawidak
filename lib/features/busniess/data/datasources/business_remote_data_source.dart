import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/features/busniess/data/models/service_model.dart';
import 'package:mawidak/features/busniess/data/models/staff_model.dart';
import 'package:mawidak/features/busniess/data/models/working_hours_model.dart';

abstract class BusinessRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<ServiceModel> createService(Map<String, dynamic> data);
  Future<ServiceModel> updateService(int id, Map<String, dynamic> data);
  Future<void> deleteService(int id);

  Future<List<StaffModel>> getStaff();
  Future<StaffModel> createStaff(Map<String, dynamic> data);
  Future<StaffModel> updateStaff(int id, Map<String, dynamic> data);

  Future<WorkingHoursModel> getWorkingHours(int staffId);
  Future<void> updateWorkingHours(
    int staffId,
    List<Map<String, dynamic>> schedule,
  );
}

@LazySingleton(as: BusinessRemoteDataSource)
class BusinessRemoteDataSourceImpl implements BusinessRemoteDataSource {
  final Dio _dio;
  BusinessRemoteDataSourceImpl(this._dio);

  // In-memory mock data store for development
  final List<ServiceModel> _mockServices = [
    const ServiceModel(
      id: 1,
      name: 'قص وتصفيف الشعر (Haircut & Styling)',
      description: 'قص شعر احترافي وتصفيف عصري مع غسيل الشعر',
      durationMinutes: 45,
      price: 150.0,
      category: 'Hair',
      isActive: true,
    ),
    const ServiceModel(
      id: 2,
      name: 'تهذيب وعناية اللحية (Beard Trim & Care)',
      description: 'تشذيب اللحية وتحديد الحواف وزيوت ترطيب طبيعية',
      durationMinutes: 30,
      price: 80.0,
      category: 'Beard',
      isActive: true,
    ),
    const ServiceModel(
      id: 3,
      name: 'صبغة وعلاج الشعر (Coloring & Treatment)',
      description: 'صبغات عالية الجودة وعلاج كيراتين وترميم للشعر',
      durationMinutes: 90,
      price: 400.0,
      category: 'Hair',
      isActive: true,
    ),
    const ServiceModel(
      id: 4,
      name: 'جلسة تنظيف وبشرة (Facial & Skin Care)',
      description: 'تنظيف عميق للبشرة بالأجهزة مع ماسكات مرطبة ومنعشة',
      durationMinutes: 60,
      price: 250.0,
      category: 'Skin',
      isActive: true,
    ),
  ];

  final List<StaffModel> _mockStaff = [
    const StaffModel(
      id: 1,
      userId: 101,
      name: 'أحمد حسن (Ahmed Hassan)',
      email: 'ahmed@mawidak.com',
      assignedServiceIds: [1, 2],
    ),
    const StaffModel(
      id: 2,
      userId: 102,
      name: 'سارة محمد (Sara Mohamed)',
      email: 'sara@mawidak.com',
      assignedServiceIds: [3, 4],
    ),
    const StaffModel(
      id: 3,
      userId: 103,
      name: 'محمود علي (Mahmoud Ali)',
      email: 'mahmoud@mawidak.com',
      assignedServiceIds: [1, 2, 4],
    ),
  ];

  final Map<int, List<Map<String, dynamic>>> _mockHours = {};

  @override
  Future<List<ServiceModel>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockServices);
  }

  @override
  Future<ServiceModel> createService(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newId = (_mockServices.isEmpty ? 0 : _mockServices.map((e) => e.id).reduce((a, b) => a > b ? a : b)) + 1;
    final model = ServiceModel(
      id: newId,
      name: data['name'] as String? ?? 'New Service',
      description: data['description'] as String? ?? '',
      durationMinutes: data['duration_minutes'] as int? ?? 30,
      price: (data['price'] as num?)?.toDouble() ?? 100.0,
      category: data['category'] as String? ?? 'General',
      isActive: data['active'] as bool? ?? true,
    );
    _mockServices.add(model);
    return model;
  }

  @override
  Future<ServiceModel> updateService(int id, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockServices.indexWhere((s) => s.id == id);
    final existing = index != -1 ? _mockServices[index] : null;

    final updated = ServiceModel(
      id: id,
      name: data['name'] as String? ?? existing?.name ?? 'Service',
      description: data['description'] as String? ?? existing?.description ?? '',
      durationMinutes: data['duration_minutes'] as int? ?? existing?.durationMinutes ?? 30,
      price: (data['price'] as num?)?.toDouble() ?? existing?.price ?? 100.0,
      category: data['category'] as String? ?? existing?.category ?? 'General',
      isActive: data['active'] as bool? ?? existing?.isActive ?? true,
    );

    if (index != -1) {
      _mockServices[index] = updated;
    } else {
      _mockServices.add(updated);
    }
    return updated;
  }

  @override
  Future<void> deleteService(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockServices.removeWhere((s) => s.id == id);
  }

  @override
  Future<List<StaffModel>> getStaff() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockStaff);
  }

  @override
  Future<StaffModel> createStaff(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newId = (_mockStaff.isEmpty ? 0 : _mockStaff.map((e) => e.id).reduce((a, b) => a > b ? a : b)) + 1;
    
    List<int> services = [];
    if (data['service_ids'] is List && (data['service_ids'] as List).isNotEmpty) {
      final cmd = (data['service_ids'] as List).first;
      if (cmd is List && cmd.length >= 3 && cmd[2] is List) {
        services = (cmd[2] as List).map((e) => e as int).toList();
      }
    }

    final model = StaffModel(
      id: newId,
      userId: data['user_id'] as int? ?? 100 + newId,
      name: data['name'] as String? ?? 'Staff Member',
      email: data['email'] as String? ?? 'staff@mawidak.com',
      assignedServiceIds: services,
    );
    _mockStaff.add(model);
    return model;
  }

  @override
  Future<StaffModel> updateStaff(int id, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockStaff.indexWhere((s) => s.id == id);
    final existing = index != -1 ? _mockStaff[index] : null;

    List<int> services = existing?.assignedServiceIds ?? [];
    if (data['service_ids'] is List && (data['service_ids'] as List).isNotEmpty) {
      final cmd = (data['service_ids'] as List).first;
      if (cmd is List && cmd.length >= 3 && cmd[2] is List) {
        services = (cmd[2] as List).map((e) => e as int).toList();
      }
    }

    final updated = StaffModel(
      id: id,
      userId: data['user_id'] as int? ?? existing?.userId ?? 100,
      name: data['name'] as String? ?? existing?.name ?? 'Staff',
      email: data['email'] as String? ?? existing?.email ?? '',
      assignedServiceIds: services,
    );

    if (index != -1) {
      _mockStaff[index] = updated;
    } else {
      _mockStaff.add(updated);
    }
    return updated;
  }

  @override
  Future<WorkingHoursModel> getWorkingHours(int staffId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final raw = _mockHours[staffId] ?? _defaultRawSchedule();
    return WorkingHoursModel.fromJson(staffId, raw);
  }

  @override
  Future<void> updateWorkingHours(
    int staffId,
    List<Map<String, dynamic>> schedule,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockHours[staffId] = schedule;
  }

  List<Map<String, dynamic>> _defaultRawSchedule() {
    return [
      {'dayofweek': 0, 'is_working': true, 'hour_from': '09:00', 'hour_to': '17:00'},
      {'dayofweek': 1, 'is_working': true, 'hour_from': '09:00', 'hour_to': '17:00'},
      {'dayofweek': 2, 'is_working': true, 'hour_from': '09:00', 'hour_to': '17:00'},
      {'dayofweek': 3, 'is_working': true, 'hour_from': '09:00', 'hour_to': '17:00'},
      {'dayofweek': 4, 'is_working': false, 'hour_from': null, 'hour_to': null},
      {'dayofweek': 5, 'is_working': false, 'hour_from': null, 'hour_to': null},
      {'dayofweek': 6, 'is_working': true, 'hour_from': '10:00', 'hour_to': '18:00'},
    ];
  }
}
