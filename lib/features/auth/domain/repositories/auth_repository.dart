import 'package:dartz/dartz.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failures, AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failures, Unit>> logout();

  Future<Either<Failures, AuthEntity?>> getSession();
}
