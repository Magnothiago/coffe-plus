/// Cliente HTTP central do app, com base URL e injeção do token Bearer.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../storage/token_storage.dart';
import 'api_config.dart';
import 'api_exception.dart';

/// Tempo máximo de espera por uma resposta antes de desistir da requisição.
///
/// Sem isso, um host inalcançável (ex.: IP errado do backend) deixa o
/// `Future` pendente para sempre, travando a UI em loading infinito.
const Duration _requestTimeout = Duration(seconds: 15);

/// Envolve [http.Client] com base URL, headers padrão, header
/// `Authorization: Bearer <token>` (quando há sessão) e mapeamento de erros
/// HTTP para [ApiException] (Req: 400/401 tratados pelo mobile).
@lazySingleton
class ApiClient {
  ApiClient(this._tokenStorage) : _client = http.Client() {
    debugPrint('[ApiClient] baseUrl = ${ApiConfig.baseUrl}');
  }

  /// Construtor para testes, permitindo injetar um [http.Client] fake.
  @visibleForTesting
  ApiClient.withClient(this._tokenStorage, this._client);

  final http.Client _client;
  final TokenStorage _tokenStorage;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, String>> _headers({bool withAuth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await _tokenStorage.readToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// `POST` sem autenticação (ex.: `/auth/login`).
  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final http.Response response;
    try {
      response = await _client
          .post(_uri(path), headers: await _headers(), body: jsonEncode(body))
          .timeout(_requestTimeout);
    } on Exception catch (e) {
      debugPrint('[ApiClient] POST $path falhou: $e');
      throw const NetworkException();
    }
    return _decode(response);
  }

  /// `GET` autenticado com `Authorization: Bearer <token>`.
  Future<dynamic> getAuthorized(String path) async {
    final http.Response response;
    try {
      response = await _client
          .get(_uri(path), headers: await _headers(withAuth: true))
          .timeout(_requestTimeout);
    } on Exception catch (e) {
      debugPrint('[ApiClient] GET $path falhou: $e');
      throw const NetworkException();
    }
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(
          _extractMessage(response) ?? 'Requisição inválida.',
        );
      case 401:
        throw UnauthorizedException(
          _extractMessage(response) ??
              'Credenciais inválidas ou sessão expirada.',
        );
      default:
        throw ApiException(
          _extractMessage(response) ?? 'Erro inesperado do servidor.',
          statusCode: response.statusCode,
        );
    }
  }

  String? _extractMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } on FormatException {
      // Corpo não é JSON válido; ignora e usa mensagem default.
    }
    return null;
  }
}
