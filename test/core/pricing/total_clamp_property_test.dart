import 'package:coffe_plus/core/pricing/pricing_calculator.dart';
import 'package:glados/glados.dart';

void main() {
  // Feature: coffee-shop-app, Property 11: Total clamps at zero after discount.
  // For any subtotal, tax and promo-code discount, the total equals
  // max(0, subtotal + tax - discount) and is never negative.
  // Validates: Requirements 6.6
  //
  // Glados3<int, int, int>() runs 100 inputs by default (ExploreConfig.numRuns).
  Glados3<int, int, int>().test(
    'total equals max(0, subtotal + tax - discount) and is never negative',
    (subtotalCents, taxCents, discountCents) {
      final total = PricingCalculator.totalCents(
        subtotalCents: subtotalCents,
        taxCents: taxCents,
        discountCents: discountCents,
      );

      final raw = subtotalCents + taxCents - discountCents;
      final expected = raw < 0 ? 0 : raw;

      expect(total, expected);
      expect(total, greaterThanOrEqualTo(0));
    },
  );
}
