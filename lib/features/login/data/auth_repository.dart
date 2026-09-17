/// Repositório de autenticação: orquestra login remoto e persistência do token.
library;

import 'package:injectable/injectable.dart';

import '../../../core/storage/token_storage.dart';
import 'auth_remote_data_source.dart';

/// Abstração do fluxo de autenticação consumido pela [LoginStore].
abstract class AuthRepository {
  /// Efetua login com [login]/[senha], salva o token retornado e o devolve.
  ///
  /// Lança [ApiException] (400/401) em caso de falha.
  Future<String> login({required String login, required String senha});
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<String> login({required String login, required String senha}) async {
    final response = await _remoteDataSource.login(login: login, senha: senha);
    await _tokenStorage.saveToken(response.token);
    return response.token;
  }
}
