import 'package:mawidak/config/di/injection.dart';
import 'package:mawidak/features/auth/domain/usecases/login_use_case.dart';
import 'package:mawidak/features/auth/domain/usecases/logout_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
LoginUseCase loginUseCase(Ref ref) => getIt<LoginUseCase>();

@riverpod
LogoutUseCase logoutUseCase(Ref ref) => getIt<LogoutUseCase>();