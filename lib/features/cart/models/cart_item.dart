/// Modelo de dados de um item adicionado ao carrinho (Reqs 2.2, 2.4).
///
/// Agrega um [Product] às opções de personalização selecionadas
/// ([size], [milk], [sweetness]) e à [quantity]. Os valores monetários
/// derivados ([unitPriceCents], [lineTotalCents]) são delegados ao
/// [PricingCalculator], mantendo os cálculos em centavos inteiros e livres de
/// erros de arredondamento de ponto flutuante.
library;

import 'package:json_annotation/json_annotation.dart';

import '../../../core/pricing/pricing_calculator.dart';
import '../../catalog/models/options.dart';
import '../../catalog/models/product.dart';

part 'cart_item.g.dart';

/// Item do carrinho serializável de/para JSON.
///
/// Usa `explicitToJson: true` para que o [Product] aninhado seja serializado
/// via seu próprio `toJson`, garantindo a propriedade de round-trip
/// `CartItem.fromJson(c.toJson()) == c` (Req 2.4).
///
/// A [quantity] deve ser >= 1. Os getters [unitPriceCents] e [lineTotalCents]
/// delegam ao [PricingCalculator]. A igualdade é por valor sobre todos os
/// campos.
@JsonSerializable(explicitToJson: true)
class CartItem {
  const CartItem({
    required this.product,
    required this.size,
    required this.milk,
    required this.sweetness,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  /// Produto referenciado por este item de carrinho.
  final Product product;

  /// Tamanho selecionado.
  final SizeOption size;

  /// Opção de leite selecionada (define o acréscimo de preço).
  final MilkOption milk;

  /// Nível de adoçamento selecionado.
  final SweetnessOption sweetness;

  /// Quantidade do item (>= 1).
  final int quantity;

  /// Preço unitário em centavos = preço base do produto + acréscimo do leite.
  int get unitPriceCents => PricingCalculator.unitPriceCents(
        basePriceCents: product.basePriceCents,
        milkSurchargeCents: milk.surchargeCents,
      );

  /// Total da linha em centavos = preço unitário × quantidade.
  int get lineTotalCents => PricingCalculator.lineTotalCents(
        unitPriceCents: unitPriceCents,
        quantity: quantity,
      );

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  /// Retorna uma cópia deste item com a [quantity] opcionalmente alterada.
  CartItem copyWith({int? quantity}) => CartItem(
        product: product,
        size: size,
        milk: milk,
        sweetness: sweetness,
        quantity: quantity ?? this.quantity,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          size == other.size &&
          milk == other.milk &&
          sweetness == other.sweetness &&
          quantity == other.quantity;

  @override
  int get hashCode => Object.hash(
        product,
        size,
        milk,
        sweetness,
        quantity,
      );
}
