/// Repositório da Home: abstrai a origem dos cafés exibidos.
library;

import 'package:injectable/injectable.dart';

import '../models/coffee.dart';
import 'home_remote_data_source.dart';

abstract class HomeRepository {
  /// Retorna a lista de cafés da Home. Lança [ApiException] em caso de falha.
  Future<List<Coffee>> getCoffees();
}

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Coffee>> getCoffees() => _remoteDataSource.getCoffees();
}
