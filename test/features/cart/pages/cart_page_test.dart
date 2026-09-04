/// Widget tests da tela "Your Cart" ([CartPage]) — Reqs 6.1, 6.5, 6.9.
///
/// Verificam a renderização integrada da tela:
/// - A lista reativa de itens exibe uma [CartLine] com o nome do produto
///   (Req 6.1).
/// - O card Order Summary exibe os rótulos Subtotal/Tax/Total (Req 6.5).
/// - Os botões "ADD ANOTHER ITEM" e "PROCEED TO CHECKOUT" estão presentes.
/// - O aviso informativo (Req 6.9) e a Bottom_Nav estão presentes.
/// - Com o carrinho vazio, "PROCEED TO CHECKOUT" fica desabilitado (Req 6.8).
///
/// A [CartPage] resolve o [CartStore] via `getIt<CartStore>()`, então cada teste
/// registra as dependências com [configureDependencies], após um
/// `getIt.reset()` para garantir idempotência entre execuções.
library;

import 'package:coffe_plus/di/injection.dart';
import 'package:coffe_plus/features/cart/models/cart_item.dart';
import 'package:coffe_plus/features/cart/pages/cart_page.dart';
import 'package:coffe_plus/features/cart/stores/cart_store.dart';
import 'package:coffe_plus/features/cart/widgets/cart_line.dart';
import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/options.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Produto de exemplo usado para popular o carrinho nos testes.
const _sampleProduct = Product(
  id: 'espresso-1',
  name: 'Cappuccino Sensorial',
  description: 'Um cappuccino cremoso.',
  basePriceCents: 550,
  imagePath: 'assets/images/coffe.jpeg',
  category: Category.espresso,
);

/// Item de exemplo pronto para adicionar ao [CartStore].
const _sampleItem = CartItem(
  product: _sampleProduct,
  size: SizeOption.oz12,
  milk: MilkOption.whole,
  sweetness: SweetnessOption.regular,
  quantity: 1,
);

/// Envolve a [CartPage] em um [MaterialApp] para o pump.
Widget _wrapCartPage() => const MaterialApp(home: CartPage());

/// Define uma janela de teste alta o suficiente para que todo o conteúdo do
/// [ListView] da [CartPage] seja construído e caiba na tela, evitando que
/// widgets abaixo da dobra fiquem fora da árvore por lazy-build.
void _useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUp(() {
    // Idempotência: limpa qualquer registro anterior antes de reconfigurar.
    getIt.reset();
    configureDependencies();
  });

  tearDown(() {
    getIt.reset();
  });

  group('CartPage — carrinho com itens (Reqs 6.1, 6.5, 6.9)', () {
    testWidgets('exibe uma CartLine com o produto adicionado', (tester) async {
      getIt<CartStore>().addItem(_sampleItem);

      await tester.pumpWidget(_wrapCartPage());
      await tester.pumpAndSettle();

      // A lista de itens renderiza uma CartLine com o nome do produto (Req 6.1).
      expect(find.byType(CartLine), findsOneWidget);
      expect(find.text(_sampleProduct.name), findsOneWidget);
    });

    testWidgets('exibe o Order Summary com Subtotal/Tax/Total', (tester) async {
      getIt<CartStore>().addItem(_sampleItem);

      await tester.pumpWidget(_wrapCartPage());
      await tester.pumpAndSettle();

      // Order Summary com os rótulos monetários (Req 6.5).
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Tax'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets(
      'exibe os botões, o aviso informativo e a Bottom_Nav',
      (tester) async {
        _useTallSurface(tester);
        getIt<CartStore>().addItem(_sampleItem);

        await tester.pumpWidget(_wrapCartPage());
        await tester.pumpAndSettle();

        // Botões de ação.
        expect(find.text('ADD ANOTHER ITEM'), findsOneWidget);
        expect(find.text('PROCEED TO CHECKOUT'), findsOneWidget);

        // Aviso informativo (Req 6.9).
        expect(
          find.textContaining('Prices include applicable taxes'),
          findsOneWidget,
        );

        // Bottom_Nav presente (fora do ListView, sempre construída).
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      },
    );
  });

  group('CartPage — carrinho vazio (Req 6.8)', () {
    testWidgets(
      'PROCEED TO CHECKOUT fica desabilitado quando o carrinho está vazio',
      (tester) async {
        _useTallSurface(tester);
        // Nenhum item adicionado ao carrinho.
        await tester.pumpWidget(_wrapCartPage());
        await tester.pumpAndSettle();

        final ElevatedButton checkoutButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'PROCEED TO CHECKOUT'),
        );

        // onPressed nulo => botão desabilitado.
        expect(checkoutButton.onPressed, isNull);
        expect(checkoutButton.enabled, isFalse);
      },
    );
  });
}
