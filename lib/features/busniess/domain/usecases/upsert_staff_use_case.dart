import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/entities/staff_entity.dart';
import 'package:mawidak/features/busniess/domain/repositories/staff_repository.dart';

@injectable
class UpsertStaffUseCase {
  final StaffRepository _repository;
  UpsertStaffUseCase(this._repository);

  Future<Either<Failures, StaffEntity>> call(StaffEntity staff) =>
      _repository.upsertStaff(staff);
}
