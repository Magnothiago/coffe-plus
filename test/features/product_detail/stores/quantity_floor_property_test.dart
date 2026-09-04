// Feature: coffee-shop-app, Property 7
//
// Property 7: Quantity floor invariant.
//
// *For any* sequência de operações de incremento e decremento a partir da
// quantidade inicial 1, a quantidade permanece sempre >= 1 e é igual a
// `max(1, 1 + (nº de incrementos − nº de decrementos aplicados acima do piso))`.
//
// Validates: Requirements 5.6, 5.7

import 'dart:math' as math;

import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/product_detail/stores/product_detail_store.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:glados/glados.dart';

/// Produto de exemplo usado para instanciar a [ProductDetailStore]. O conteúdo
/// do produto é irrelevante para a Property 7 (que só observa `quantity`).
const _sampleProduct = Product(
  id: 'p1',
  name: 'Signature Lavender Latte',
  description: 'A soothing floral espresso.',
  basePriceCents: 550,
  imagePath: 'assets/images/coffe.jpeg',
  category: Category.espresso,
);

/// Gerador customizado `any.incDecSequence`: uma lista de operações onde
/// `true` representa um incremento e `false` um decremento.
extension AnyIncDecSequence on Any {
  /// Sequência de operações de incremento (`true`) / decremento (`false`).
  Generator<List<bool>> get incDecSequence =>
      any.listWithLengthInRange(0, 60, any.bool);
}

void main() {
  // Feature: coffee-shop-app, Property 7
  //
  // Aplica uma sequência arbitrária de increment()/decrement() na
  // [ProductDetailStore] a partir da quantidade inicial 1 e verifica:
  //   1. A quantidade permanece sempre >= 1 em TODOS os passos (piso, Req 5.7).
  //   2. Ao final, a quantidade é igual ao modelo de referência
  //      `max(1, 1 + (incrementos − decrementos aplicados acima do piso))`,
  //      simulado passo a passo (Reqs 5.6, 5.7).
  Glados<List<bool>>(
    any.incDecSequence,
    ExploreConfig(numRuns: 100),
  ).test(
    'Property 7: quantity never drops below 1 and matches the reference model',
    (ops) {
      final store = ProductDetailStore(_sampleProduct);

      // Modelo de referência: mesma regra de piso do `decrement`.
      var expected = 1;

      // Estado inicial é 1 (Req 5.6, default).
      expect(store.quantity, 1);
      expect(store.quantity, greaterThanOrEqualTo(1));

      for (final isIncrement in ops) {
        if (isIncrement) {
          store.increment();
          expected = expected + 1;
        } else {
          store.decrement();
          expected = math.max(1, expected - 1);
        }

        // Invariante de piso: nunca abaixo de 1 em nenhum passo.
        expect(
          store.quantity,
          greaterThanOrEqualTo(1),
          reason: 'quantity caiu abaixo do piso de 1',
        );

        // A quantidade acompanha exatamente o modelo de referência.
        expect(
          store.quantity,
          expected,
          reason: 'quantity divergiu do modelo de referência',
        );
      }

      expect(store.quantity, expected);
      expect(store.quantity, greaterThanOrEqualTo(1));
    },
  );
}
