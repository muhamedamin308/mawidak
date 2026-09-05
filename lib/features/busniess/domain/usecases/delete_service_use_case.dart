import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/repositories/service_repository.dart';

@injectable
class DeleteServiceUseCase {
  final ServiceRepository _repository;
  DeleteServiceUseCase(this._repository);

  Future<Either<Failures, Unit>> call(int id) => _repository.deleteService(id);
}
