/// Fonte de dados remota de autenticação (`POST /auth/login`).
library;

import 'package:injectable/injectable.dart';

import '../../../core/network/api_client.dart';
import '../models/auth_response.dart';

/// Consome o endpoint de login do backend.
@lazySingleton
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// Efetua login com [login]/[senha]. Lança [ApiException] (400/401) em
  /// caso de falha, propagada pelo [ApiClient].
  Future<AuthResponse> login({
    required String login,
    required String senha,
  }) async {
    final json = await _apiClient.post('/auth/login', {
      'login': login,
      'senha': senha,
    });
    return AuthResponse.fromJson(json as Map<String, dynamic>);
  }
}
