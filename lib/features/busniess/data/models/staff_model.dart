import 'package:mawidak/features/busniess/domain/entities/staff_entity.dart';

class StaffModel {
  final int id;
  final int userId;
  final String name;
  final String email;
  final List<int> assignedServiceIds;

  const StaffModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.assignedServiceIds,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
    id: json['id'] as int,
    userId: json['user_id'] is List
        ? (json['user_id'] as List).first as int
        : json['user_id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    assignedServiceIds:
        (json['service_ids'] as List?)?.map((e) => e as int).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'email': email,
    'service_ids': [
      [6, 0, assignedServiceIds],
    ], // Odoo many2many replace command
  };

  StaffEntity toEntity() => StaffEntity(
    id: id,
    userId: userId,
    name: name,
    email: email,
    assignedServiceIds: assignedServiceIds,
  );

  static StaffModel fromEntity(StaffEntity e) => StaffModel(
    id: e.id ?? 0,
    userId: e.userId,
    name: e.name,
    email: e.email,
    assignedServiceIds: e.assignedServiceIds,
  );
}
