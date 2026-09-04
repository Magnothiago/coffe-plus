import 'package:coffe_plus/core/pricing/pricing_calculator.dart';
import 'package:coffe_plus/features/catalog/models/options.dart';
import 'package:glados/glados.dart';

/// Gerador de [MilkOption] arbitrário (whole, oat ou almond).
Generator<MilkOption> get anyMilkOption =>
    any.choose(MilkOption.values);

void main() {
  // Feature: coffee-shop-app, Property 6: Unit price includes milk surcharge.
  //
  // For any preço base (em centavos) e for any MilkOption, o preço unitário
  // calculado é igual ao preço base somado ao acréscimo daquela opção de leite:
  // unitPriceCents == basePriceCents + milk.surchargeCents.
  //
  // Validates: Requirements 5.5
  Glados2<int, MilkOption>(
    // basePriceCents em [0, 100000], conforme faixa de preços do design.
    any.intInRange(0, 100001),
    anyMilkOption,
    ExploreConfig(numRuns: 100),
  ).test(
    'unitPriceCents equals basePriceCents plus milk surcharge',
    (basePriceCents, milk) {
      final result = PricingCalculator.unitPriceCents(
        basePriceCents: basePriceCents,
        milkSurchargeCents: milk.surchargeCents,
      );

      expect(result, equals(basePriceCents + milk.surchargeCents));
    },
  );
}
