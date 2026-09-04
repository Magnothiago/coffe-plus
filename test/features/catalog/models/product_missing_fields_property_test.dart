import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:glados/glados.dart';

/// Conjunto de assets de imagem existentes em `assets/images/`.
///
/// O gerador `anyProduct` seleciona `imagePath` deste conjunto, conforme a
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

/// Campos obrigatórios de [Product] no JSON (sem valor default).
const _requiredFields = <String>[
  'id',
  'name',
  'description',
  'basePriceCents',
  'imagePath',
  'category',
];

/// Gerador de [Category] arbitrário (espresso, brewed ou coldBrew).
Generator<Category> get anyCategory => any.choose(Category.values);

/// Gerador de caminho de imagem a partir do conjunto de assets existentes.
Generator<String> get anyImagePath => any.choose(_existingImagePaths);

/// Gerador customizado `anyProduct`.
///
/// Gera um [Product] válido reutilizando o padrão do teste de round-trip.
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
  // Feature: coffee-shop-app, Property 3: Missing required fields fail
  // deserialization.
  //
  // Para qualquer Product válido, ao remover cada campo obrigatório (id, name,
  // description, basePriceCents, imagePath, category) do JSON produzido por
  // p.toJson(), Product.fromJson deve lançar um erro de desserialização.
  //
  // Validates: Requirements 2.5
  Glados<Product>(anyProduct, ExploreConfig(numRuns: 100)).test(
    'removing any required field makes Product.fromJson throw',
    (product) {
      for (final field in _requiredFields) {
        final json = product.toJson()..remove(field);

        expect(
          () => Product.fromJson(json),
          throwsA(anything),
          reason: 'esperava erro ao desserializar com o campo "$field" ausente',
        );
      }
    },
  );
}
