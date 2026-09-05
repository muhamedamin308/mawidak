abstract class Failures {
  final String? message;
  const Failures({required this.message});
}

class ServerFailure extends Failures {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failures {
  const CacheFailure({required super.message});
}

class AuthFailure extends Failures {
  const AuthFailure({required super.message});
}
