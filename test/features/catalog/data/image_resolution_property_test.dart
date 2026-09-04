import 'package:coffe_plus/features/catalog/data/local_product_data_source.dart';
import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:glados/glados.dart';

/// Instância única do resolver sob teste.
const _dataSource = LocalProductDataSource();

/// Conjunto de assets existentes exposto pela fonte de dados.
final _existingAssets = LocalProductDataSource.existingAssets;

/// Amostra de caminhos de imagem que exercitam os três ramos de resolução:
/// - caminhos que pertencem a `existingAssets` (mapeados/válidos);
/// - a string vazia (ausente);
/// - caminhos arbitrários que provavelmente não existem (não mapeados).
const _candidateImagePaths = <String>[
  // Assets existentes.
  'assets/images/coffe.jpeg',
  'assets/images/coffe_only.jpeg',
  'assets/images/soda.jpeg',
  // Ausente / vazio.
  '',
  // Não mapeados / inexistentes.
  'assets/images/does_not_exist.png',
  'assets/images/coffe.png',
  'coffe.jpeg',
  'assets/images/COFFE.JPEG',
  'https://example.com/coffe.jpeg',
];

/// Amostra de ids que exercitam o fallback por id:
/// - ids mapeados em `imagePathById` (p1–p5);
/// - ids desconhecidos que caem no default.
const _candidateIds = <String>[
  'p1',
  'p2',
  'p3',
  'p4',
  'p5',
  'unknown',
  '',
  'zzz',
];

/// Gerador de um caminho de imagem candidato (existente, ausente ou inexistente).
Generator<String> get anyCandidateImagePath =>
    any.choose(_candidateImagePaths);

/// Gerador de um id candidato (mapeado ou desconhecido).
Generator<String> get anyCandidateId => any.choose(_candidateIds);

/// Gerador de [Category] arbitrário.
Generator<Category> get anyCategory => any.choose(Category.values);

/// Gerador de [Product] com id e imagePath potencialmente inexistentes,
/// para exercitar mapeamento, ausência e fallback.
Generator<Product> get anyProductForResolution => any.combine4(
      anyCandidateId,
      anyCandidateImagePath,
      any.intInRange(0, 100001),
      anyCategory,
      (id, imagePath, basePriceCents, category) => Product(
        id: id,
        name: 'name',
        description: 'description',
        basePriceCents: basePriceCents,
        imagePath: imagePath,
        category: category,
      ),
    );

void main() {
  // Feature: coffee-shop-app, Property 15: Image resolution always yields an
  // existing asset.
  //
  // For any Product (com imagem mapeada, ausente ou não mapeada), o caminho de
  // imagem resolvido pertence ao conjunto de arquivos existentes em
  // `assets/images/`; quando não há imagem específica, o resolver retorna a
  // imagem padrão existente (`assets/images/coffe.jpeg`).
  //
  // Validates: Requirements 7.1, 7.3
  Glados<Product>(anyProductForResolution, ExploreConfig(numRuns: 100)).test(
    'resolveImagePath always yields an existing asset',
    (product) {
      final resolved = _dataSource.resolveImagePath(product);

      // O caminho resolvido sempre pertence ao conjunto de assets existentes.
      expect(_existingAssets.contains(resolved), isTrue);

      // Quando não há imagem específica (imagePath não é um asset existente e
      // o id não mapeia para um asset existente), o resolver retorna o default.
      final imagePathIsExisting = _existingAssets.contains(product.imagePath);
      final mappedForId = LocalProductDataSource.imagePathById[product.id];
      final idResolvesToExisting =
          mappedForId != null && _existingAssets.contains(mappedForId);
      if (!imagePathIsExisting && !idResolvesToExisting) {
        expect(resolved, equals(LocalProductDataSource.defaultImagePath));
      }
    },
  );

  // Verifica também a API resolveImage({id, imagePath}) diretamente com pares
  // arbitrários de id/imagePath, incluindo valores nulos (ausentes).
  Glados2<String, String>(
    anyCandidateId,
    anyCandidateImagePath,
    ExploreConfig(numRuns: 100),
  ).test(
    'resolveImage always yields an existing asset for arbitrary id/imagePath',
    (id, imagePath) {
      final resolved = _dataSource.resolveImage(id: id, imagePath: imagePath);

      expect(_existingAssets.contains(resolved), isTrue);

      final imagePathIsExisting = _existingAssets.contains(imagePath);
      final mappedForId = LocalProductDataSource.imagePathById[id];
      final idResolvesToExisting =
          mappedForId != null && _existingAssets.contains(mappedForId);
      if (!imagePathIsExisting && !idResolvesToExisting) {
        expect(resolved, equals(LocalProductDataSource.defaultImagePath));
      }
    },
  );
}
