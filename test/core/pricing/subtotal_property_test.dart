import 'package:coffe_plus/core/pricing/pricing_calculator.dart';
import 'package:glados/glados.dart';

// Feature: coffee-shop-app, Property 10: Subtotal is the sum of line totals
//
// For any list of line totals (in cents), PricingCalculator.subtotalCents
// equals the plain sum of all of them. This mirrors the cart Subtotal being
// the sum of every present item's Line_Total, including after quantity
// changes or removals.
//
// Validates: Requirements 6.2, 6.3, 6.4
void main() {
  // Line totals derive from unitPrice x quantity, both non-negative, so the
  // input space is lists of non-negative integer cents.
  final anyLineTotal = any.intInRange(0, 1000000);
  final anyLineTotals = any.listWithLengthInRange(0, 30, anyLineTotal);

  Glados<List<int>>(anyLineTotals).test(
    'subtotalCents equals the sum of all line totals',
    (lineTotals) {
      final expected = lineTotals.fold<int>(0, (sum, lt) => sum + lt);

      expect(PricingCalculator.subtotalCents(lineTotals), expected);
    },
  );
}
