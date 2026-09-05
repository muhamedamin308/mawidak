import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/failures.dart';
import 'package:mawidak/features/auth/domain/entities/auth_entity.dart';
import 'package:mawidak/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failures, AuthEntity>> call({
    required String email,
    required String password,
  }) => _authRepository.login(email: email, password: password);
}
