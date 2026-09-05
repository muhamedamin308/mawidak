import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/busniess/domain/entities/staff_entity.dart';
import 'package:mawidak/features/busniess/domain/repositories/staff_repository.dart';

@injectable
class GetStaffUseCase {
  final StaffRepository _repository;
  GetStaffUseCase(this._repository);

  Future<Either<Failures, List<StaffEntity>>> call() => _repository.getStaff();
}
