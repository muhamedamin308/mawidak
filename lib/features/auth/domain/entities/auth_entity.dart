enum UserRole { customer, staff, admin }

class AuthEntity {
  final int userId;
  final String name;
  final String email;
  final String sessionId;
  final UserRole role;

  const AuthEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.sessionId,
    required this.role,
  });
}
