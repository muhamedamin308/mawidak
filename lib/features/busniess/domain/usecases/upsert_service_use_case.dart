import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/entities/service_entity.dart';
import 'package:mawidak/features/busniess/domain/repositories/service_repository.dart';

@injectable
class UpsertServiceUseCase {
  final ServiceRepository _repository;
  UpsertServiceUseCase(this._repository);

  Future<Either<Failures, ServiceEntity>> call(ServiceEntity service) =>
      _repository.upsertService(service);
}