import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/entities/working_hours_entity.dart';
import 'package:mawidak/features/busniess/domain/repositories/working_hours_repository.dart';

@injectable
class UpdateWorkingHoursUseCase {
  final WorkingHoursRepository _repository;
  UpdateWorkingHoursUseCase(this._repository);

  Future<Either<Failures, Unit>> call(WorkingHoursEntity hours) =>
      _repository.updateWorkingHours(hours);
}
