import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../features/catalog/models/product.dart';
import '../features/product_detail/stores/product_detail_store.dart';
import 'injection.config.dart';

/// Instância global do service locator GetIt.
final GetIt getIt = GetIt.instance;

/// Registra todas as dependências injetáveis do app antes de a UI ser exibida.
///
/// A implementação de [init] é gerada por injectable em `injection.config.dart`.
@InjectableInit()
void configureDependencies() => getIt.init();

/// Módulo de registro para dependências que recebem parâmetros de runtime.
///
/// [ProductDetailStore] é uma store MobX no padrão de classe-apelido
/// (`class X = XBase with _$X`), o que impede que a anotação `@factoryParam`
/// do construtor base seja detectada pelo injectable diretamente na classe.
/// Registrá-la aqui via método de módulo permite que o [Product] selecionado
/// seja injetado como `@factoryParam` no momento da resolução (Req 1.5).
@module
abstract class ProductDetailModule {
  @injectable
  ProductDetailStore productDetailStore(@factoryParam Product product) =>
      ProductDetailStore(product);
}
