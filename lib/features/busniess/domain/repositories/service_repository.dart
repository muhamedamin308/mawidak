import 'package:dartz/dartz.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/entities/service_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failures, List<ServiceEntity>>> getServices();
  Future<Either<Failures, ServiceEntity>> upsertService(ServiceEntity service);
  Future<Either<Failures, Unit>> deleteService(int id);
}