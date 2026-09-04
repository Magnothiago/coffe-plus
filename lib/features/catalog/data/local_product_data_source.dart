/// Fonte de dados local do catálogo (Reqs 4.9, 7.1, 7.3).
///
/// Fornece o catálogo mockado fixo de 5 produtos (p1–p5) definido no design e
/// resolve o caminho de imagem de cada produto garantindo que o resultado
/// sempre aponte para um asset existente em `assets/images/`. Quando o
/// [Product.imagePath] está ausente ou não mapeia para um arquivo existente, o
/// resolver retorna a imagem padrão [defaultImagePath] (Req 7.3).
library;

import 'package:injectable/injectable.dart';

import '../models/category.dart';
import '../models/product.dart';

/// Catálogo mockado local e resolver de imagens do app "The Sensory Pour".
@lazySingleton
class LocalProductDataSource {
  const LocalProductDataSource();

  /// Imagem padrão usada como fallback quando um caminho não resolve (Req 7.3).
  static const String defaultImagePath = 'assets/images/coffe.jpeg';

  /// Conjunto de assets efetivamente presentes em `assets/images/`.
  ///
  /// O resolver de imagem só considera válido um caminho que pertença a este
  /// conjunto; qualquer outro cai no [defaultImagePath] (Req 7.1, 7.3).
  static const Set<String> existingAssets = {
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
  };

  /// Mapeamento `id -> imagePath` usando apenas assets existentes (Req 7.1).
  static const Map<String, String> imagePathById = {
    'p1': 'assets/images/coffe.jpeg',
    'p2': 'assets/images/coffe_only.jpeg',
    'p3': 'assets/images/coffe_3.jpeg',
    'p4': 'assets/images/croassant.jpeg',
    'p5': 'assets/images/coffe_one.jpeg',
  };

  /// Catálogo mockado fixo de 5 produtos (Req 4.9).
  static const List<Product> _catalog = [
    Product(
      id: 'p1',
      name: 'Signature Lavender Latte',
      description:
          'Espresso encorpado com leite vaporizado e um toque floral de '
          'lavanda. Nosso carro-chefe, equilibrado e aromático.',
      basePriceCents: 550,
      imagePath: 'assets/images/coffe.jpeg',
      category: Category.espresso,
      tags: ['floral', 'signature', 'latte'],
      featured: true,
    ),
    Product(
      id: 'p2',
      name: 'Double Espresso',
      description:
          'Duas doses intensas de espresso puro, com crema aveludada e final '
          'prolongado. Para quem busca energia sem rodeios.',
      basePriceCents: 350,
      imagePath: 'assets/images/coffe_only.jpeg',
      category: Category.espresso,
      tags: ['intenso', 'clássico'],
      featured: false,
    ),
    Product(
      id: 'p3',
      name: 'Iced Americano',
      description:
          'Espresso alongado servido sobre gelo, refrescante e leve. '
          'A escolha certa para os dias quentes.',
      basePriceCents: 400,
      imagePath: 'assets/images/coffe_3.jpeg',
      category: Category.coldBrew,
      tags: ['gelado', 'refrescante'],
      featured: false,
    ),
    Product(
      id: 'p4',
      name: 'Butter Croissant',
      description:
          'Croissant folhado amanteigado, assado diariamente. '
          'O acompanhamento perfeito para o seu café.',
      basePriceCents: 450,
      imagePath: 'assets/images/croassant.jpeg',
      category: Category.brewed,
      tags: ['padaria', 'amanteigado'],
      featured: false,
    ),
    Product(
      id: 'p5',
      name: 'Pour Over V60',
      description:
          'Método coado artesanal em V60, realçando as notas delicadas de '
          'grãos selecionados. Uma experiência sensorial.',
      basePriceCents: 500,
      imagePath: 'assets/images/coffe_one.jpeg',
      category: Category.brewed,
      tags: ['coado', 'artesanal', 'single origin'],
      featured: false,
    ),
  ];

  /// Retorna a lista imutável de produtos do catálogo mockado (Req 4.9).
  List<Product> getProducts() => List.unmodifiable(_catalog);

  /// Resolve o caminho de imagem de um [product], garantindo um asset existente.
  ///
  /// Ordem de resolução (Req 7.1, 7.3):
  /// 1. Se o [Product.imagePath] pertence a [existingAssets], usa-o.
  /// 2. Senão, se há um mapeamento por [Product.id] para um asset existente,
  ///    usa-o.
  /// 3. Caso contrário, retorna [defaultImagePath].
  String resolveImagePath(Product product) =>
      resolveImage(id: product.id, imagePath: product.imagePath);

  /// Resolve um caminho de imagem a partir de um [id] e/ou [imagePath].
  ///
  /// Sempre retorna um caminho pertencente a [existingAssets] (Req 7.1, 7.3).
  String resolveImage({String? id, String? imagePath}) {
    if (imagePath != null && existingAssets.contains(imagePath)) {
      return imagePath;
    }
    if (id != null) {
      final mapped = imagePathById[id];
      if (mapped != null && existingAssets.contains(mapped)) {
        return mapped;
      }
    }
    return defaultImagePath;
  }
}
