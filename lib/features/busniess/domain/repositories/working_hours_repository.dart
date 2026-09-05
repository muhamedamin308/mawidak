import 'package:dartz/dartz.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/entities/working_hours_entity.dart';

abstract class WorkingHoursRepository {
  Future<Either<Failures, WorkingHoursEntity>> getWorkingHours(int staffId);
  Future<Either<Failures, Unit>> updateWorkingHours(WorkingHoursEntity hours);
}
