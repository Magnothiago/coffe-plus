import 'package:coffe_plus/features/cart/models/cart_item.dart';
import 'package:coffe_plus/features/cart/stores/cart_store.dart';
import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/options.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:glados/glados.dart';

/// Conjunto de assets existentes em `assets/images/`, usado para gerar
/// `imagePath` de produtos válidos (conforme design: `any.product` usa apenas
/// caminhos de assets existentes).
const _imagePaths = <String>[
  'assets/images/coffe.jpeg',
  'assets/images/coffe_only.jpeg',
  'assets/images/coffe_3.jpeg',
  'assets/images/coffe_one.jpeg',
  'assets/images/coffe_details.jpeg',
  'assets/images/croassant.jpeg',
];

/// Geradores customizados para os modelos do domínio de catálogo/carrinho,
/// reutilizando o padrão `any.product`/`any.cartItem` dos demais testes.
extension AnyCheckoutModels on Any {
  /// Gera uma [Category] arbitrária.
  Generator<Category> get category => any.choose(Category.values);

  /// Gera uma [SizeOption] arbitrária.
  Generator<SizeOption> get sizeOption => any.choose(SizeOption.values);

  /// Gera uma [MilkOption] arbitrária.
  Generator<MilkOption> get milkOption => any.choose(MilkOption.values);

  /// Gera uma [SweetnessOption] arbitrária.
  Generator<SweetnessOption> get sweetnessOption =>
      any.choose(SweetnessOption.values);

  /// Gera um caminho de imagem pertencente aos assets existentes.
  Generator<String> get imagePath => any.choose(_imagePaths);

  /// Gera um [Product] válido.
  Generator<Product> get product => any.combine8(
        any.letters,
        any.letters,
        any.letters,
        any.intInRange(0, 100001),
        any.imagePath,
        any.category,
        any.listWithLengthInRange(0, 5, any.letters),
        any.bool,
        (String id, String name, String description, int basePriceCents,
                String imagePath, Category category, List<String> tags,
                bool featured) =>
            Product(
          id: id,
          name: name,
          description: description,
          basePriceCents: basePriceCents,
          imagePath: imagePath,
          category: category,
          tags: tags,
          featured: featured,
        ),
      );

  /// Gera um [CartItem] válido com `quantity` em [1, 50].
  Generator<CartItem> get cartItem => any.combine5(
        any.product,
        any.sizeOption,
        any.milkOption,
        any.sweetnessOption,
        any.intInRange(1, 51),
        (Product product, SizeOption size, MilkOption milk,
                SweetnessOption sweetness, int quantity) =>
            CartItem(
          product: product,
          size: size,
          milk: milk,
          sweetness: sweetness,
          quantity: quantity,
        ),
      );
}

void main() {
  // Feature: coffee-shop-app, Property 12
  //
  // Checkout availability mirrors cart emptiness: para qualquer estado do
  // carrinho, PROCEED TO CHECKOUT está habilitado se e somente se o carrinho
  // possui ao menos um item — ou seja, `checkoutEnabled == !cartStore.isEmpty`.
  //
  // A partir de uma lista gerada de [CartItem]s adicionada ao [CartStore],
  // verifica-se que `(!isEmpty) == items.isNotEmpty`, cobrindo tanto o caso de
  // carrinho vazio (checkout desabilitado) quanto o de carrinho não-vazio
  // (checkout habilitado).
  //
  // Validates: Requirements 6.8
  Glados<List<CartItem>>(
    any.listWithLengthInRange(0, 20, any.cartItem),
    ExploreConfig(numRuns: 100),
  ).test(
    'checkout enabled (!isEmpty) mirrors cart emptiness for any cart state',
    (cartItems) {
      final store = CartStore();
      for (final item in cartItems) {
        store.addItem(item);
      }

      // PROCEED TO CHECKOUT fica habilitado exatamente quando há itens.
      final bool checkoutEnabled = !store.isEmpty;

      expect(checkoutEnabled, equals(store.items.isNotEmpty));
      expect(store.isEmpty, equals(cartItems.isEmpty));
    },
  );
}
