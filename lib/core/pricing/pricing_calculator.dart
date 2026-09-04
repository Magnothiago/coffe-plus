/// Cálculos puros de precificação, sempre em centavos inteiros (`int`).
///
/// Não possui estado nem dependências. Operar em centavos evita erros de
/// arredondamento de ponto flutuante; a conversão para exibição (ex.: `$5.50`)
/// ocorre apenas na camada de formatação da UI.
class PricingCalculator {
  const PricingCalculator._();

  /// Preço unitário = preço base do produto + acréscimo do leite (em centavos).
  static int unitPriceCents({
    required int basePriceCents,
    required int milkSurchargeCents,
  }) =>
      basePriceCents + milkSurchargeCents;

  /// Line total = preço unitário × quantidade.
  static int lineTotalCents({
    required int unitPriceCents,
    required int quantity,
  }) =>
      unitPriceCents * quantity;

  /// Subtotal = soma dos line totals.
  static int subtotalCents(Iterable<int> lineTotals) =>
      lineTotals.fold(0, (a, b) => a + b);

  /// Tax = arredondamento do subtotal × taxRate (ex.: 0.08 → 8%).
  static int taxCents(int subtotalCents, double taxRate) =>
      (subtotalCents * taxRate).round();

  /// Total = subtotal + tax − desconto, com piso em 0.
  static int totalCents({
    required int subtotalCents,
    required int taxCents,
    required int discountCents,
  }) {
    final t = subtotalCents + taxCents - discountCents;
    return t < 0 ? 0 : t;
  }
}
