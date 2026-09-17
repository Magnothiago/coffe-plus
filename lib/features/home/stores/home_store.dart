/// Store MobX da tela Home (lista de cafés vinda do backend).
library;

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../core/network/api_exception.dart';
import '../data/home_repository.dart';
import '../models/coffee.dart';

part 'home_store.g.dart';

@injectable
class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  HomeStoreBase(this._repository);

  final HomeRepository _repository;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<Coffee> coffees = ObservableList<Coffee>();

  /// Carrega a lista de cafés a partir de `GET /home/coffees`.
  @action
  Future<void> loadCoffees() async {
    isLoading = true;
    errorMessage = null;
    try {
      final result = await _repository.getCoffees();
      coffees = ObservableList.of(result);
    } on UnauthorizedException {
      errorMessage = 'Sessão expirada. Faça login novamente.';
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
    }
  }
}
