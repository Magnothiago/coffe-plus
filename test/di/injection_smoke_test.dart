import 'package:coffe_plus/di/injection.dart';
import 'package:coffe_plus/features/cart/stores/cart_store.dart';
import 'package:coffe_plus/features/catalog/data/local_product_data_source.dart';
import 'package:coffe_plus/features/catalog/data/product_repository.dart';
import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:coffe_plus/features/login/stores/login_store.dart';
import 'package:coffe_plus/features/menu/stores/menu_store.dart';
import 'package:coffe_plus/features/product_detail/stores/product_detail_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// Smoke test do wiring de injeção de dependências (Reqs 1.4, 1.5).
///
/// Após [configureDependencies], o service locator [getIt] deve resolver todas
/// as dependências principais do app: as Stores (Login, Menu, Cart,
/// ProductDetail), o [ProductRepository] e o [LocalProductDataSource].
///
/// [ProductDetailStore] é registrada como `factoryParam` (recebe o [Product]
/// selecionado em runtime), portanto é resolvida com `param1` (Req 1.5).
///
/// [getIt.reset] em `setUp`/`tearDown` mantém o teste idempotente, evitando
/// erros de re-registro quando `configureDependencies` é chamado novamente.
void main() {
  /// Produto de exemplo para resolver a [ProductDetailStore] via `factoryParam`.
  const sampleProduct = Product(
    id: 'p1',
    name: 'Signature Lavender Latte',
    description: 'Espresso encorpado com um toque floral de lavanda.',
    basePriceCents: 550,
    imagePath: 'assets/images/coffe.jpeg',
    category: Category.espresso,
  );

  group('configureDependencies() DI wiring (Reqs 1.4, 1.5)', () {
    setUp(() async {
      await getIt.reset();
      configureDependencies();
    });

    tearDown(() => getIt.reset());

    test('getIt resolve LoginStore', () {
      expect(getIt<LoginStore>(), isA<LoginStore>());
    });

    test('getIt resolve MenuStore', () {
      expect(getIt<MenuStore>(), isA<MenuStore>());
    });

    test('getIt resolve CartStore', () {
      expect(getIt<CartStore>(), isA<CartStore>());
    });

    test('getIt resolve ProductRepository', () {
      expect(getIt<ProductRepository>(), isA<ProductRepository>());
    });

    test('getIt resolve LocalProductDataSource', () {
      expect(getIt<LocalProductDataSource>(), isA<LocalProductDataSource>());
    });

    test('getIt resolve ProductDetailStore via factoryParam (Req 1.5)', () {
      final store = getIt<ProductDetailStore>(param1: sampleProduct);

      expect(store, isA<ProductDetailStore>());
      expect(store.product, sampleProduct);
    });
  });
}
