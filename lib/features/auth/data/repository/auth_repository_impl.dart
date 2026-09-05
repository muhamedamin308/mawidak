import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/exception.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mawidak/features/auth/domain/entities/auth_entity.dart';
import 'package:mawidak/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;

  AuthRepositoryImpl(this._remote);

  @override
  Future<Either<Failures, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remote.login(email: email, password: password);
      return Right(model.toEntity());
    } on AuthException catch (ae) {
      return Left(AuthFailure(message: ae.message));
    } on ServerException catch (se) {
      return Left(ServerFailure(message: se.message));
    }
  }

  @override
  Future<Either<Failures, Unit>> logout() async {
    try {
      await _remote.logout();
      return const Right(unit);
    } on ServerException catch (se) {
      return Left(ServerFailure(message: se.message));
    }
  }

  @override
  Future<Either<Failures, AuthEntity?>> getSession() async {
    return const Right(null);
  }
}
