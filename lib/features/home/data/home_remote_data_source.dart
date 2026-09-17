/// Fonte de dados remota da Home (`GET /home/coffees`).
library;

import 'package:injectable/injectable.dart';

import '../../../core/network/api_client.dart';
import '../models/coffee.dart';

/// Consome o endpoint autenticado de listagem de cafés da Home.
@lazySingleton
class HomeRemoteDataSource {
  const HomeRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// Busca a lista de cafés. Lança [ApiException] (401) se o token estiver
  /// ausente, inválido ou expirado.
  Future<List<Coffee>> getCoffees() async {
    final json = await _apiClient.getAuthorized('/home/coffees');
    return (json as List<dynamic>)
        .map((item) => Coffee.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
