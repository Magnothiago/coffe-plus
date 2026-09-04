import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/options.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:coffe_plus/features/product_detail/stores/product_detail_store.dart';
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

/// Combinação de seleções aplicadas à [ProductDetailStore] e verificadas no
/// [CartItem] resultante.
class _Selections {
  const _Selections({
    required this.product,
    required this.size,
    required this.milk,
    required this.sweetness,
    required this.quantity,
  });

  final Product product;
  final SizeOption size;
  final MilkOption milk;
  final SweetnessOption sweetness;
  final int quantity;
}

/// Geradores customizados reutilizando o padrão `any.product`.
extension AnyProductDetailSelections on Any {
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

  /// Gera uma combinação de seleções (produto, tamanho, leite, adoçamento e
  /// quantidade >= 1) a serem aplicadas na [ProductDetailStore].
  Generator<_Selections> get productDetailSelections => any.combine5(
        any.product,
        any.sizeOption,
        any.milkOption,
        any.sweetnessOption,
        any.intInRange(1, 51),
        (Product product, SizeOption size, MilkOption milk,
                SweetnessOption sweetness, int quantity) =>
            _Selections(
          product: product,
          size: size,
          milk: milk,
          sweetness: sweetness,
          quantity: quantity,
        ),
      );
}

void main() {
  // Feature: coffee-shop-app, Property 9: Added cart item preserves selections.
  //
  // For any combinação de Product, Size_Option, Milk_Option, Sweetness_Option e
  // quantidade selecionados, o CartItem adicionado ao Carrinho possui
  // exatamente esses valores em seus campos.
  //
  // Validates: Requirements 4.7, 5.9
  Glados<_Selections>(
    any.productDetailSelections,
    ExploreConfig(numRuns: 100),
  ).test(
    'buildCartItem() preserves the selected product and options',
    (selections) {
      final store = ProductDetailStore(selections.product);

      store.selectSize(selections.size);
      store.selectMilk(selections.milk);
      store.selectSweetness(selections.sweetness);

      // A quantidade inicial da store é 1; incrementa até atingir o alvo (>= 1).
      for (var q = 1; q < selections.quantity; q++) {
        store.increment();
      }

      final cartItem = store.buildCartItem();

      expect(cartItem.product, equals(selections.product));
      expect(cartItem.size, equals(selections.size));
      expect(cartItem.milk, equals(selections.milk));
      expect(cartItem.sweetness, equals(selections.sweetness));
      expect(cartItem.quantity, equals(selections.quantity));
    },
  );
}
