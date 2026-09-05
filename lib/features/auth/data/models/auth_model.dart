import 'package:mawidak/features/auth/domain/entities/auth_entity.dart';

class AuthModel {
  final int uid;
  final String name;
  final String email;
  final String sessionId;
  final String roleKey; // stored in res.users via a custom 'mawidak_role' field

  const AuthModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.sessionId,
    required this.roleKey,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json, String sessionId) {
    return AuthModel(
      uid: json['uid'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      sessionId: sessionId,
      roleKey: json['mawidak_role'] as String? ?? 'customer',
    );
  }

  AuthEntity toEntity() => AuthEntity(
    userId: uid,
    name: name,
    email: email,
    sessionId: sessionId,
    role: _parseRole(roleKey),
  );

  static UserRole _parseRole(String key) => switch (key) {
    'staff' => UserRole.staff,
    'admin' => UserRole.admin,
    _ => UserRole.customer,
  };
}
