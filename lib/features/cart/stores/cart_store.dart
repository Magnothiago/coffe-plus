/// Store MobX do Carrinho de Compras ("Your Cart") — Reqs 1.5, 4.7, 6.2–6.8.
///
/// Gerencia a lista reativa de [CartItem]s e o estado do Promo_Code. Todos os
/// valores monetários derivados ([subtotalCents], [taxCents], [totalCents]) são
/// calculados em centavos inteiros via [PricingCalculator], evitando erros de
/// arredondamento de ponto flutuante.
///
/// Registrada como `@lazySingleton` pois o carrinho é compartilhado entre as
/// telas de Menu, Detalhes do Produto e Carrinho (design: escopos de registro).
library;

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../core/pricing/pricing_calculator.dart';
import '../../catalog/models/options.dart';
import '../../catalog/models/product.dart';
import '../models/cart_item.dart';

part 'cart_store.g.dart';

/// Alíquota de imposto aplicada sobre o subtotal (8%).
const double _kTaxRate = 0.08;

/// Códigos promocionais válidos e o desconto correspondente em centavos.
const Map<String, int> _kValidPromoCodes = {
  'SENSORY10': 100, // $1.00 de desconto
};

/// Store do Carrinho.
@lazySingleton
class CartStore = CartStoreBase with _$CartStore;

abstract class CartStoreBase with Store {
  /// Itens atualmente no carrinho.
  @observable
  ObservableList<CartItem> items = ObservableList<CartItem>();

  /// Código promocional informado pelo cliente.
  @observable
  String promoCode = '';

  /// Desconto aplicado em centavos (0 quando nenhum código válido está ativo).
  @observable
  int appliedDiscountCents = 0;

  /// Mensagem de erro do Promo_Code (nula quando não há erro) — Req 6.7.
  @observable
  String? promoError;

  /// Subtotal = soma dos Line_Total de todos os itens — Reqs 6.2, 6.3, 6.4.
  @computed
  int get subtotalCents =>
      PricingCalculator.subtotalCents(items.map((item) => item.lineTotalCents));

  /// Tax = arredondamento do subtotal × alíquota.
  @computed
  int get taxCents => PricingCalculator.taxCents(subtotalCents, _kTaxRate);

  /// Total = subtotal + tax − desconto, com piso em 0 — Req 6.6.
  @computed
  int get totalCents => PricingCalculator.totalCents(
        subtotalCents: subtotalCents,
        taxCents: taxCents,
        discountCents: appliedDiscountCents,
      );

  /// `true` quando o carrinho não contém nenhum item — Req 6.8.
  @computed
  bool get isEmpty => items.isEmpty;

  /// Adiciona um [CartItem] já configurado ao carrinho — Req 5.9.
  @action
  void addItem(CartItem item) => items.add(item);

  /// Adiciona um [Product] com as opções padrão — Req 4.7.
  ///
  /// Opções padrão: tamanho 12oz, Whole Milk, adoçamento Regular, quantidade 1.
  @action
  void addProductWithDefaults(Product product) {
    items.add(
      CartItem(
        product: product,
        size: SizeOption.oz12,
        milk: MilkOption.whole,
        sweetness: SweetnessOption.regular,
        quantity: 1,
      ),
    );
  }

  /// Atualiza a quantidade do item no [index] informado — Req 6.2.
  ///
  /// A quantidade é limitada a um piso de 1. Índices fora do intervalo são
  /// ignorados.
  @action
  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= items.length) {
      return;
    }
    final int clamped = quantity < 1 ? 1 : quantity;
    items[index] = items[index].copyWith(quantity: clamped);
  }

  /// Remove o item no [index] informado do carrinho — Req 6.3.
  ///
  /// Índices fora do intervalo são ignorados.
  @action
  void removeItem(int index) {
    if (index < 0 || index >= items.length) {
      return;
    }
    items.removeAt(index);
  }

  /// Aplica um Promo_Code — Reqs 6.6, 6.7.
  ///
  /// Não lança: em caso de código inválido, define [promoError] e mantém
  /// [appliedDiscountCents] em 0. Em caso de código válido, aplica o desconto
  /// correspondente e limpa [promoError].
  @action
  void applyPromo(String code) {
    promoCode = code;
    final String normalized = code.trim().toUpperCase();
    final int? discount = _kValidPromoCodes[normalized];
    if (discount == null) {
      appliedDiscountCents = 0;
      promoError = 'Invalid promo code';
      return;
    }
    appliedDiscountCents = discount;
    promoError = null;
  }
}
