// Feature: coffee-shop-app, Property 8: Line total equals unit price times quantity
//
// *For any* preço unitário e *for any* quantidade >= 1, o total exibido no
// botão ADD TO CART é igual a `unitPriceCents × quantity`.
//
// Validates: Requirements 5.8

import 'package:coffe_plus/core/pricing/pricing_calculator.dart';
import 'package:glados/glados.dart';

void main() {
  // Gerador de preço unitário: centavos não-negativos em faixa realista.
  final anyUnitPriceCents = any.intInRange(0, 100001); // [0, 100000]
  // Gerador de quantidade >= 1 (piso do domínio, ver Property 7 / Req 5.7).
  final anyQuantity = any.intInRange(1, 51); // [1, 50]

  Glados2<int, int>(
    anyUnitPriceCents,
    anyQuantity,
    ExploreConfig(numRuns: 100),
  ).test(
    'Property 8: lineTotalCents == unitPriceCents * quantity (>= 1)',
    (unitPriceCents, quantity) {
      final lineTotal = PricingCalculator.lineTotalCents(
        unitPriceCents: unitPriceCents,
        quantity: quantity,
      );

      expect(quantity, greaterThanOrEqualTo(1));
      expect(lineTotal, unitPriceCents * quantity);
    },
  );
}
