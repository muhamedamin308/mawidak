import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mawidak/core/error/exception.dart';
import 'package:mawidak/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/web/session/authenticate',
        data: {
          'jsonrpc': '2.0',
          'method': 'call',
          'params': {'db': 'mawidak_db', 'login': email, 'password': password},
        },
      );

      final result = response.data['result'];
      if (result == null || result['uid'] == null) {
        throw AuthException('Invalid credentials');
      }

      // Extracting the session ID 
      final setCookies = response.headers['set-cookie']?.first ?? '';
      final sessionId = _extractSessionId(setCookies);

      final userDetails = await _fetchUserRole(result['uid'] as int, sessionId);

      return AuthModel.fromJson({...result, ...userDetails}, sessionId);
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error');
    }
  }

  String _extractSessionId(String cookie) {
    final match = RegExp(r'session_id=([^;]+)').firstMatch(cookie);
    return match?.group(1) ?? '';
  }

  Future<Map<String, dynamic>> _fetchUserRole(int uid, String sessionId) async {
    final response = await _dio.post(
      '/web/dataset/call_kw',
      options: Options(headers: {'Cookie': 'session_id=$sessionId'}),
      data: {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'model': 'res.users',
          'method': 'read',
          'args': [
            [uid],
            ['mawidak_role'],
          ],
          'kwargs': {},
        },
      },
    );
    final records = response.data['result'] as List;
    return records.isNotEmpty ? records.first as Map<String, dynamic> : {};
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(
        '/web/session/destroy',
        data: {'jsonrpc': '2.0', 'method': 'call', 'params': {}},
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
