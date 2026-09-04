import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testes de edge case (baseados em exemplos concretos) para a
/// desserialização de [Product] (Req 2.5).
///
/// Complementam o teste de propriedade `product_missing_fields_property_test`
/// com exemplos fixos e explícitos: partindo de um JSON válido, cada campo
/// obrigatório é removido individualmente e verifica-se que
/// [Product.fromJson] lança.
void main() {
  // JSON válido de referência. Todos os campos (obrigatórios e opcionais)
  // presentes para servir de base às remoções.
  Map<String, dynamic> validProductJson() => <String, dynamic>{
        'id': 'signature-lavender-latte',
        'name': 'Signature Lavender Latte',
        'description': 'Espresso suave com nota floral de lavanda.',
        'basePriceCents': 550,
        'imagePath': 'assets/images/coffe.jpeg',
        'category': 'espresso',
        'tags': <String>['floral', 'signature'],
        'featured': true,
      };

  group('Product.fromJson - campo obrigatório ausente lança erro (Req 2.5)',
      () {
    test('JSON válido de referência desserializa sem erro (sanity check)', () {
      expect(() => Product.fromJson(validProductJson()), returnsNormally);
    });

    test('remover "id" faz Product.fromJson lançar', () {
      final json = validProductJson()..remove('id');
      expect(() => Product.fromJson(json), throwsA(anything));
    });

    test('remover "name" faz Product.fromJson lançar', () {
      final json = validProductJson()..remove('name');
      expect(() => Product.fromJson(json), throwsA(anything));
    });

    test('remover "description" faz Product.fromJson lançar', () {
      final json = validProductJson()..remove('description');
      expect(() => Product.fromJson(json), throwsA(anything));
    });

    test('remover "basePriceCents" faz Product.fromJson lançar', () {
      final json = validProductJson()..remove('basePriceCents');
      expect(() => Product.fromJson(json), throwsA(anything));
    });

    test('remover "imagePath" faz Product.fromJson lançar', () {
      final json = validProductJson()..remove('imagePath');
      expect(() => Product.fromJson(json), throwsA(anything));
    });

    test('remover "category" faz Product.fromJson lançar', () {
      final json = validProductJson()..remove('category');
      expect(() => Product.fromJson(json), throwsA(anything));
    });
  });
}
