import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/entities/service_entity.dart';
import 'package:mawidak/features/busniess/domain/repositories/service_repository.dart';

@injectable
class GetServicesUseCase {
  final ServiceRepository _repository;
  GetServicesUseCase(this._repository);

  Future<Either<Failures, List<ServiceEntity>>> call() =>
      _repository.getServices();
}
