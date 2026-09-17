/// Exceções tipadas para respostas de erro da API.
library;

/// Erro genérico de comunicação com a API, carregando o [statusCode] HTTP
/// (quando disponível) e uma [message] amigável para exibição ao usuário.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Erro de requisição inválida (`400 Bad Request`).
class BadRequestException extends ApiException {
  const BadRequestException([super.message = 'Requisição inválida.'])
    : super(statusCode: 400);
}

/// Erro de autenticação/autorização (`401 Unauthorized`).
class UnauthorizedException extends ApiException {
  const UnauthorizedException([
    super.message = 'Credenciais inválidas ou sessão expirada.',
  ]) : super(statusCode: 401);
}

/// Erro de falha de conexão com o backend (host inacessível, timeout, etc.).
class NetworkException extends ApiException {
  const NetworkException([
    super.message = 'Não foi possível conectar ao servidor.',
  ]);
}
