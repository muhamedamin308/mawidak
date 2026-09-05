import 'package:mawidak/features/busniess/domain/entities/service_entity.dart';

class ServiceModel {
  final int id;
  final String name;
  final String description;
  final int durationMinutes;
  final double price;
  final String category;
  final bool isActive;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.price,
    required this.category,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    durationMinutes: json['duration_minutes'] as int,
    price: (json['price'] as num).toDouble(),
    category: json['category'] as String? ?? '',
    isActive: json['active'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'duration_minutes': durationMinutes,
    'price': price,
    'category': category,
    'active': isActive,
  };

  ServiceEntity toEntity() => ServiceEntity(
    id: id,
    name: name,
    description: description,
    durationMinutes: durationMinutes,
    price: price,
    category: category,
    isActive: isActive,
  );

  static ServiceModel fromEntity(ServiceEntity entity) => ServiceModel(
    id: entity.id ?? 0,
    name: entity.name,
    description: entity.description ?? '',
    durationMinutes: entity.durationMinutes,
    price: entity.price,
    category: entity.category ?? '',
    isActive: entity.isActive,
  );
}
