import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/exception.dart';
import 'package:mawidak/core/error/failures.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/business_remote_data_source.dart';
import '../models/service_model.dart';

@LazySingleton(as: ServiceRepository)
class ServiceRepositoryImpl implements ServiceRepository {
  final BusinessRemoteDataSource _remote;
  ServiceRepositoryImpl(this._remote);

  @override
  Future<Either<Failures, List<ServiceEntity>>> getServices() async {
    try {
      final models = await _remote.getServices();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failures, ServiceEntity>> upsertService(
    ServiceEntity service,
  ) async {
    try {
      final data = ServiceModel.fromEntity(service).toJson();
      final model = service.id == null
          ? await _remote.createService(data)
          : await _remote.updateService(service.id!, data);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failures, Unit>> deleteService(int id) async {
    try {
      await _remote.deleteService(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
