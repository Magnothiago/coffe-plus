/// Resposta de sucesso do endpoint `POST /auth/login`.
library;

import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

/// Token JWT emitido pelo backend e o tipo de esquema de autorização.
@JsonSerializable()
class AuthResponse {
  const AuthResponse({required this.token, required this.type});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  final String token;
  final String type;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
