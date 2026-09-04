/// Opções de personalização de um produto (Reqs 5.2, 5.3, 5.4).
///
/// Todos os acréscimos de preço são expressos em centavos inteiros para evitar
/// erros de arredondamento de ponto flutuante nos cálculos monetários.
library;

/// Opção de tamanho da bebida (8oz, 12oz, 16oz) — Req 5.2.
enum SizeOption { oz8, oz12, oz16 }

/// Opção de leite, cada uma com um acréscimo de preço em centavos — Req 5.3.
///
/// - [whole]: Whole Milk, sem acréscimo (0).
/// - [oat]: Oat Milk, acréscimo de 75 centavos (+$0.75).
/// - [almond]: Almond Milk, acréscimo de 75 centavos (+$0.75).
enum MilkOption {
  whole(surchargeCents: 0),
  oat(surchargeCents: 75),
  almond(surchargeCents: 75);

  const MilkOption({required this.surchargeCents});

  /// Acréscimo de preço em centavos aplicado ao preço base do produto.
  final int surchargeCents;
}

/// Nível de adoçamento da bebida (None, Light, Regular) — Req 5.4.
enum SweetnessOption { none, light, regular }
