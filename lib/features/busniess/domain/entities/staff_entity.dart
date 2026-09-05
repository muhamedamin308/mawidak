class StaffEntity {
  final int? id;
  final int userId;
  final String name;
  final String email;
  final List<int> assignedServiceIds;

  const StaffEntity({
    this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.assignedServiceIds,
  });
}
