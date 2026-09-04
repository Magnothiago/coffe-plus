/// Store MobX da tela de Detalhes do Produto — Reqs 1.5, 5.3, 5.5–5.9.
///
/// Mantém o [Product] selecionado e as opções de personalização como estado
/// observável, deriva o preço unitário e o total via [PricingCalculator]
/// (centavos inteiros) e constrói o [CartItem] correspondente às seleções
/// atuais. Registrada como factory recebendo o [Product] como parâmetro de
/// runtime via `@factoryParam` (design: escopos de registro).
library;

import 'dart:math' as math;

import 'package:mobx/mobx.dart';

import '../../../core/pricing/pricing_calculator.dart';
import '../../cart/models/cart_item.dart';
import '../../catalog/models/options.dart';
import '../../catalog/models/product.dart';

part 'product_detail_store.g.dart';

/// Store da tela de Detalhes do Produto.
///
/// O registro em DI é feito via `@module` (ver `lib/di/injection.dart`), que
/// expõe uma factory recebendo o [Product] como `@factoryParam`. Isso é
/// necessário porque a anotação `@factoryParam` no construtor da base MobX
/// (`ProductDetailStoreBase`) não é propagada através da classe-apelido
/// `class ProductDetailStore = ... with _$ProductDetailStore`.
class ProductDetailStore = ProductDetailStoreBase with _$ProductDetailStore;

/// Base da [ProductDetailStore] com o estado observável, computeds e actions.
abstract class ProductDetailStoreBase with Store {
  ProductDetailStoreBase(this.product);

  /// Produto exibido nesta tela.
  final Product product;

  /// Tamanho selecionado (padrão: 12oz) — Req 5.2.
  @observable
  SizeOption size = SizeOption.oz12;

  /// Opção de leite selecionada (padrão: Whole Milk) — Req 5.3.
  @observable
  MilkOption milk = MilkOption.whole;

  /// Nível de adoçamento selecionado (padrão: Regular) — Req 5.4.
  @observable
  SweetnessOption sweetness = SweetnessOption.regular;

  /// Quantidade selecionada (padrão: 1, com piso em 1) — Reqs 5.6, 5.7.
  @observable
  int quantity = 1;

  /// Preço unitário em centavos = preço base + acréscimo do leite — Req 5.5.
  @computed
  int get unitPriceCents => PricingCalculator.unitPriceCents(
        basePriceCents: product.basePriceCents,
        milkSurchargeCents: milk.surchargeCents,
      );

  /// Preço total em centavos = preço unitário × quantidade — Req 5.8.
  @computed
  int get totalPriceCents => PricingCalculator.lineTotalCents(
        unitPriceCents: unitPriceCents,
        quantity: quantity,
      );

  /// Seleciona o tamanho da bebida.
  @action
  void selectSize(SizeOption option) => size = option;

  /// Seleciona a opção de leite (altera o preço unitário) — Req 5.5.
  @action
  void selectMilk(MilkOption option) => milk = option;

  /// Seleciona o nível de adoçamento.
  @action
  void selectSweetness(SweetnessOption option) => sweetness = option;

  /// Incrementa a quantidade em 1 — Req 5.6.
  @action
  void increment() => quantity = quantity + 1;

  /// Decrementa a quantidade, mantendo o piso em 1 — Req 5.7.
  @action
  void decrement() => quantity = math.max(1, quantity - 1);

  /// Constrói um [CartItem] com o produto e as seleções atuais — Req 5.9.
  CartItem buildCartItem() => CartItem(
        product: product,
        size: size,
        milk: milk,
        sweetness: sweetness,
        quantity: quantity,
      );
}
