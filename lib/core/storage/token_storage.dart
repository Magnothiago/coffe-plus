/// Persistência segura do token JWT emitido pelo backend.
library;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Abstração de armazenamento do token de autenticação.
abstract class TokenStorage {
  /// Salva o [token] recebido no login.
  Future<void> saveToken(String token);

  /// Lê o token salvo, ou `null` se não houver sessão.
  Future<String?> readToken();

  /// Remove o token salvo (logout).
  Future<void> clearToken();
}

/// Implementação apoiada em [FlutterSecureStorage] (Keychain/Keystore).
@LazySingleton(as: TokenStorage)
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage() : _storage = const FlutterSecureStorage();

  /// Construtor para testes, permitindo injetar um [FlutterSecureStorage] fake.
  @visibleForTesting
  SecureTokenStorage.withStorage(this._storage);

  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> clearToken() => _storage.delete(key: _tokenKey);
}
