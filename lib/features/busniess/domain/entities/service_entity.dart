class ServiceEntity {
  final int? id;
  final String name;
  final String? description;
  final int durationMinutes;
  final double price;
  final String? category;
  final bool isActive;

  const ServiceEntity({
    this.id,
    required this.name,
    this.description,
    required this.durationMinutes,
    required this.price,
    this.category,
    this.isActive = true,
  });
}
