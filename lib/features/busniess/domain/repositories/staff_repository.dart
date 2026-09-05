import 'package:dartz/dartz.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/entities/staff_entity.dart';

abstract class StaffRepository {
  Future<Either<Failures, List<StaffEntity>>> getStaff();
  Future<Either<Failures, StaffEntity>> upsertStaff(StaffEntity staff);
}
