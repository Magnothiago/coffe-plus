/// Widget tests da tela de Menu ("Explorar Sabores") ([MenuPage]) —
/// Reqs 4.1, 4.2, 4.3, 4.6, 4.8, 4.9.
///
/// Verificam a renderização integrada da tela e a navegação:
/// - App bar com título "The Sensory Pour", ícone de menu e avatar (Req 4.1).
/// - Chips de filtro de categoria Espresso/Brewed/Cold Brew (Req 4.2).
/// - Cards de produto ([ProductCard]) com nome/descrição/preço e botão "+"
///   (Req 4.3).
/// - Conteúdo/preços do catálogo: categoria padrão espresso mostra
///   "Signature Lavender Latte" e "$5.50" (Req 4.9).
/// - Bottom_Nav com Home/Menu/Cart/Profile (Req 4.8).
/// - Navegação: tocar em um card leva à [ProductDetailPage] (Req 4.6).
///
/// A [MenuPage] resolve MenuStore/CartStore/LocalProductDataSource via `getIt`,
/// então cada teste registra as dependências com [configureDependencies], após
/// um `getIt.reset()` para garantir idempotência entre execuções. A página é
/// montada dentro de um [MaterialApp] com [AppRoutes.onGenerateRoute] para que
/// tocar em um card possa navegar para a tela de detalhes.
library;

import 'package:coffe_plus/core/routing/app_routes.dart';
import 'package:coffe_plus/di/injection.dart';
import 'package:coffe_plus/features/menu/pages/menu_page.dart';
import 'package:coffe_plus/features/menu/widgets/product_card.dart';
import 'package:coffe_plus/features/product_detail/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Envolve a [MenuPage] em um [MaterialApp] com o gerador de rotas do app,
/// permitindo que a navegação nomeada (product detail, cart) funcione.
///
/// Os assets de imagem não existem no ambiente de teste; o [ProductCard] usa o
/// `errorBuilder` do `Image.asset` para exibir um fallback com tamanho, de modo
/// que o layout dos cards permanece válido sem depender do carregamento real.
Widget _wrapMenuPage() => MaterialApp(
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: const MenuPage(),
    );

/// Define uma janela de teste alta o suficiente para que os cards da lista
/// preguiçosa ([ListView]) sejam construídos e caibam na tela, evitando que
/// itens abaixo da dobra fiquem fora da árvore por lazy-build.
void _useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUp(() async {
    // Idempotência: limpa qualquer registro anterior antes de reconfigurar.
    await getIt.reset();
    configureDependencies();
  });

  tearDown(() async {
    await getIt.reset();
  });

  /// Monta a [MenuPage] em uma superfície alta e estabiliza as frames.
  Future<void> pumpMenu(WidgetTester tester) async {
    _useTallSurface(tester);
    await tester.pumpWidget(_wrapMenuPage());
    await tester.pumpAndSettle();
  }

  group('MenuPage — app bar (Req 4.1)', () {
    testWidgets('exibe título, ícone de menu e avatar', (tester) async {
      await pumpMenu(tester);

      // Título "The Sensory Pour" na AppBar.
      final appBarTitle = find.descendant(
        of: find.byType(AppBar),
        matching: find.text('The Sensory Pour'),
      );
      expect(appBarTitle, findsOneWidget);

      // Ícone de menu.
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Avatar (CircleAvatar).
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  group('MenuPage — filtros de categoria (Req 4.2)', () {
    testWidgets('exibe chips Espresso / Brewed / Cold Brew', (tester) async {
      await pumpMenu(tester);

      expect(find.text('Espresso'), findsOneWidget);
      expect(find.text('Brewed'), findsOneWidget);
      expect(find.text('Cold Brew'), findsOneWidget);

      // Os filtros são renderizados como ChoiceChips.
      expect(find.byType(ChoiceChip), findsNWidgets(3));
    });
  });

  group('MenuPage — cards de produto (Reqs 4.3, 4.9)', () {
    testWidgets(
      'exibe ProductCard com nome, descrição, preço e botão "+"',
      (tester) async {
        await pumpMenu(tester);

        // Ao menos um card de produto renderizado (categoria padrão espresso).
        expect(find.byType(ProductCard), findsWidgets);

        // Conteúdo do catálogo: categoria padrão espresso (Req 4.9).
        expect(find.text('Signature Lavender Latte'), findsOneWidget);
        expect(find.text('\$5.50'), findsOneWidget);

        // Double Espresso também pertence à categoria espresso ($3.50).
        expect(find.text('Double Espresso'), findsOneWidget);
        expect(find.text('\$3.50'), findsOneWidget);

        // Descrição do produto em destaque aparece no card.
        expect(
          find.textContaining('lavanda'),
          findsWidgets,
        );

        // Botão "+" (ícone add) presente em cada card.
        expect(find.byIcon(Icons.add), findsWidgets);
      },
    );
  });

  group('MenuPage — Bottom_Nav (Req 4.8)', () {
    testWidgets('exibe destinos Home / Menu / Cart / Profile', (tester) async {
      await pumpMenu(tester);

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });
  });

  group('MenuPage — navegação para detalhes (Req 4.6)', () {
    testWidgets(
      'tocar em um card navega para a ProductDetailPage',
      (tester) async {
        await pumpMenu(tester);

        // Toca no card do produto em destaque na categoria padrão.
        final cardFinder = find.ancestor(
          of: find.text('Signature Lavender Latte'),
          matching: find.byType(ProductCard),
        );
        expect(cardFinder, findsOneWidget);

        await tester.tap(cardFinder);
        await tester.pumpAndSettle();

        // A tela de detalhes do produto é exibida.
        expect(find.byType(ProductDetailPage), findsOneWidget);
        // O nome do produto aparece na tela de detalhes (AppBar + corpo).
        expect(find.text('Signature Lavender Latte'), findsWidgets);
      },
    );
  });
}
