import 'package:coffe_plus/features/cart/models/cart_item.dart';
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

/// Geradores customizados para os modelos do domínio de catálogo/carrinho.
extension AnyCartModels on Any {
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

  /// Gera um [Product] válido: strings arbitrárias, `basePriceCents` em
  /// [0, 100000], categoria/tags/featured aleatórios e `imagePath` do conjunto
  /// de assets existentes.
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

  /// Gera um [CartItem] válido combinando [product] com opções aleatórias e
  /// `quantity` em [1, 50].
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
  // Feature: coffee-shop-app, Property 2: CartItem serialization round-trip
  //
  // For any CartItem válido (com Product aninhado, opções e quantidade >= 1),
  // desserializar o resultado de sua serialização JSON produz um CartItem igual
  // ao original: CartItem.fromJson(c.toJson()) == c.
  //
  // Validates: Requirements 2.4
  Glados<CartItem>(
    any.cartItem,
    ExploreConfig(numRuns: 100),
  ).test(
    'CartItem.fromJson(c.toJson()) equals the original CartItem',
    (cartItem) {
      final roundTripped = CartItem.fromJson(cartItem.toJson());

      expect(roundTripped, equals(cartItem));
    },
  );
}
