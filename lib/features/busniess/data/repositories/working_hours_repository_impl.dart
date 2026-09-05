import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/exception.dart';
import 'package:mawidak/core/error/failures.dart';
import '../../domain/entities/working_hours_entity.dart';
import '../../domain/repositories/working_hours_repository.dart';
import '../datasources/business_remote_data_source.dart';

@LazySingleton(as: WorkingHoursRepository)
class WorkingHoursRepositoryImpl implements WorkingHoursRepository {
  final BusinessRemoteDataSource _remote;
  WorkingHoursRepositoryImpl(this._remote);

  @override
  Future<Either<Failures, WorkingHoursEntity>> getWorkingHours(
    int staffId,
  ) async {
    try {
      final model = await _remote.getWorkingHours(staffId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failures, Unit>> updateWorkingHours(
    WorkingHoursEntity hours,
  ) async {
    try {
      final schedule = hours.daySchedule
          .map(
            (s) => {
              'dayofweek': s.day.index,
              'is_working': s.isWorking,
              'hour_from': s.startTime,
              'hour_to': s.endTime,
            },
          )
          .toList();
      await _remote.updateWorkingHours(hours.staffId, schedule);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message:  e.message));
    }
  }
}
