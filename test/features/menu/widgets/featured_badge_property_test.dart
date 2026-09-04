import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:coffe_plus/features/menu/widgets/product_card.dart';
import 'package:glados/glados.dart';

/// Conjunto de assets de imagem existentes em `assets/images/`.
///
/// O gerador `any.product` seleciona `imagePath` deste conjunto, conforme a
/// Testing Strategy do design (imagens do conjunto de assets existentes).
const _existingImagePaths = <String>[
  'assets/images/background_login.jpeg',
  'assets/images/coffe.jpeg',
  'assets/images/coffe_3.jpeg',
  'assets/images/coffe_details.jpeg',
  'assets/images/coffe_one.jpeg',
  'assets/images/coffe_only.jpeg',
  'assets/images/croassant.jpeg',
  'assets/images/croassant_two.jpeg',
  'assets/images/download.jpeg',
  'assets/images/email.jpeg',
  'assets/images/eye.jpeg',
  'assets/images/home.jpeg',
  'assets/images/login.jpeg',
  'assets/images/order_details.jpeg',
  'assets/images/soda.jpeg',
];

/// Gerador de [Category] arbitrário (espresso, brewed ou coldBrew).
Generator<Category> get anyCategory => any.choose(Category.values);

/// Gerador de caminho de imagem a partir do conjunto de assets existentes.
Generator<String> get anyImagePath => any.choose(_existingImagePaths);

/// Gerador customizado `any.product`.
///
/// Gera um [Product] válido com strings arbitrárias, `basePriceCents` em
/// `[0, 100000]`, categoria/tags/featured aleatórios e `imagePath` do conjunto
/// de assets existentes (mesma estratégia do design/`any.product`).
Generator<Product> get anyProduct => any.combine8(
      any.letters,
      any.letters,
      any.letters,
      any.intInRange(0, 100001),
      anyImagePath,
      anyCategory,
      any.listWithLengthInRange(0, 5, any.letters),
      any.bool,
      (id, name, description, basePriceCents, imagePath, category, tags,
              featured) =>
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

void main() {
  // Feature: coffee-shop-app, Property 14
  //
  // Property 14: Featured badge reflects the flag.
  //
  // For any Product, o card correspondente exibe o badge "FEATURED" se e
  // somente se `product.featured` é verdadeiro. Aqui testamos a lógica de
  // decisão pura (`shouldShowFeaturedBadge`) que o ProductCard usa para decidir
  // a exibição do badge, sem renderizar UI.
  //
  // Validates: Requirements 4.4
  Glados<Product>(anyProduct, ExploreConfig(numRuns: 100)).test(
    'shouldShowFeaturedBadge(product) equals product.featured',
    (product) {
      expect(shouldShowFeaturedBadge(product), equals(product.featured));
    },
  );
}
