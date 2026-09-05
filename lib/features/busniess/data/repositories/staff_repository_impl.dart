import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/exception.dart';
import 'package:mawidak/core/error/failures.dart';
import '../../domain/entities/staff_entity.dart';
import '../../domain/repositories/staff_repository.dart';
import '../datasources/business_remote_data_source.dart';
import '../models/staff_model.dart';

@LazySingleton(as: StaffRepository)
class StaffRepositoryImpl implements StaffRepository {
  final BusinessRemoteDataSource _remote;
  StaffRepositoryImpl(this._remote);

  @override
  Future<Either<Failures, List<StaffEntity>>> getStaff() async {
    try {
      final models = await _remote.getStaff();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failures, StaffEntity>> upsertStaff(StaffEntity staff) async {
    try {
      final data = StaffModel.fromEntity(staff).toJson();
      final model = staff.id == null
          ? await _remote.createStaff(data)
          : await _remote.updateStaff(staff.id!, data);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
