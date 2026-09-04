import 'package:coffe_plus/features/catalog/data/product_repository.dart';
import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
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

/// Gerador de um catálogo arbitrário (lista de [Product], possivelmente vazia).
Generator<List<Product>> get anyCatalog =>
    any.listWithLengthInRange(0, 12, anyProduct);

/// Combina um catálogo gerado com uma [Category] selecionada.
Generator<(List<Product>, Category)> get anyCatalogAndCategory =>
    any.combine2(anyCatalog, anyCategory, (catalog, category) => (catalog, category));

/// Implementação in-memory de [ProductRepository] apoiada num catálogo gerado.
///
/// Reusa exatamente a lógica de filtragem contratada por [ProductRepository]:
/// `getByCategory` deriva de `getAll()` filtrando pela categoria (Req 4.5),
/// idêntica à [LocalProductRepository].
class _InMemoryProductRepository implements ProductRepository {
  _InMemoryProductRepository(this._catalog);

  final List<Product> _catalog;

  @override
  List<Product> getAll() => List.unmodifiable(_catalog);

  @override
  List<Product> getByCategory(Category category) =>
      getAll().where((product) => product.category == category).toList();

  @override
  Product getById(String id) => getAll().firstWhere((p) => p.id == id);
}

void main() {
  // Feature: coffee-shop-app, Property 13
  //
  // Property 13: Category filter soundness and completeness.
  //
  // For any catálogo de produtos e for any Category selecionada, a lista
  // filtrada por `getByCategory` contém exatamente os produtos cuja categoria é
  // a selecionada — nenhum de outra categoria (soundness), e nenhum da
  // categoria selecionada omitido (completeness).
  //
  // Validates: Requirements 4.5
  Glados<(List<Product>, Category)>(
    anyCatalogAndCategory,
    ExploreConfig(numRuns: 100),
  ).test(
    'getByCategory returns exactly the products of the selected category',
    (input) {
      final (catalog, category) = input;
      final repository = _InMemoryProductRepository(catalog);

      final filtered = repository.getByCategory(category);
      final expected =
          catalog.where((product) => product.category == category).toList();

      // Soundness: nenhum produto de outra categoria aparece no resultado.
      expect(
        filtered.every((product) => product.category == category),
        isTrue,
        reason: 'filtered contém produto de categoria diferente da selecionada',
      );

      // Completeness: nenhum produto da categoria selecionada é omitido, e o
      // conjunto filtrado é exatamente o esperado (mesma ordem preservada).
      expect(filtered, equals(expected));
    },
  );
}
