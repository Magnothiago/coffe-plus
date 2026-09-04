/// Repositório de produtos do catálogo (Reqs 4.5, 4.9).
///
/// Define a abstração [ProductRepository] consumida pelas Stores (Menu,
/// Detalhes) e sua implementação local [LocalProductRepository], que delega a
/// origem dos dados ao [LocalProductDataSource]. A filtragem por categoria é
/// derivada de [getAll], garantindo uma única fonte de verdade para o catálogo.
library;

import 'package:injectable/injectable.dart';

import '../models/category.dart';
import '../models/product.dart';
import 'local_product_data_source.dart';

/// Abstração de acesso ao catálogo de produtos.
abstract class ProductRepository {
  /// Retorna todos os produtos do catálogo.
  List<Product> getAll();

  /// Retorna os produtos cuja categoria é [category] (Req 4.5).
  List<Product> getByCategory(Category category);

  /// Retorna o produto cujo `id` é [id].
  ///
  /// Lança [StateError] quando nenhum produto corresponde ao [id].
  Product getById(String id);
}

/// Implementação local de [ProductRepository] apoiada no [LocalProductDataSource].
///
/// Registrada como [ProductRepository] em escopo [lazySingleton], pois o estado
/// do catálogo é global e imutável.
@LazySingleton(as: ProductRepository)
class LocalProductRepository implements ProductRepository {
  const LocalProductRepository(this._dataSource);

  final LocalProductDataSource _dataSource;

  @override
  List<Product> getAll() => _dataSource.getProducts();

  @override
  List<Product> getByCategory(Category category) =>
      getAll().where((product) => product.category == category).toList();

  @override
  Product getById(String id) =>
      getAll().firstWhere((product) => product.id == id);
}
