/// Store MobX da tela de Menu ("Explorar Sabores") (Reqs 1.5, 4.5).
///
/// Mantém a [Category] selecionada como estado observável e deriva a lista de
/// produtos exibida (`filteredProducts`) a partir do [ProductRepository],
/// garantindo que a UI reaja à troca de filtro. Registrada como [injectable]
/// (factory) para que cada abertura da tela receba uma instância nova.
library;

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../catalog/data/product_repository.dart';
import '../../catalog/models/category.dart';
import '../../catalog/models/product.dart';

part 'menu_store.g.dart';

/// Store da tela de Menu.
@injectable
class MenuStore = MenuStoreBase with _$MenuStore;

/// Base da [MenuStore] com o estado observável, computeds e actions.
abstract class MenuStoreBase with Store {
  MenuStoreBase(this._repository);

  final ProductRepository _repository;

  /// Categoria atualmente selecionada no filtro (padrão: [Category.espresso]).
  @observable
  Category selectedCategory = Category.espresso;

  /// Produtos pertencentes à [selectedCategory] (Req 4.5).
  @computed
  List<Product> get filteredProducts =>
      _repository.getByCategory(selectedCategory);

  /// Seleciona a [Category] a ser exibida no Menu.
  @action
  void selectCategory(Category category) => selectedCategory = category;
}
