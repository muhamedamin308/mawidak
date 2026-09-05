import 'package:mawidak/features/auth/domain/entities/auth_entity.dart';
import 'package:mawidak/features/auth/presentation/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthEntity user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String error;
  const AuthError(this.error);
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthInitial();

  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    final result = await ref.read(loginUseCaseProvider)(
      email: email,
      password: password,
    );
    state = result.fold(
      (failure) => AuthError(failure.message ?? 'Unknown error occurred'),
      (user) => AuthAuthenticated(user),
    );
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider)();
    state = const AuthUnauthenticated();
  }
}
