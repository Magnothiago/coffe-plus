import 'package:coffe_plus/di/injection.dart';
import 'package:coffe_plus/features/catalog/models/category.dart';
import 'package:coffe_plus/features/catalog/models/product.dart';
import 'package:coffe_plus/features/product_detail/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget tests da tela de Detalhes do Produto — Reqs 5.1, 5.2, 5.3, 5.4.
///
/// A [ProductDetailPage] resolve suas stores via [getIt], portanto
/// [configureDependencies] é chamado em `setUp` (com [getIt.reset] para
/// idempotência) e desfeito em `tearDown`.
void main() {
  /// Produto de exemplo com tags para exercitar a exibição dos chips (Req 5.1).
  const sampleProduct = Product(
    id: 'p1',
    name: 'Signature Lavender Latte',
    description: 'Espresso encorpado com um toque floral de lavanda.',
    basePriceCents: 550,
    imagePath: 'assets/images/coffe.jpeg',
    category: Category.espresso,
    tags: ['Floral', 'Signature'],
  );

  setUp(() async {
    await getIt.reset();
    configureDependencies();
  });

  tearDown(() => getIt.reset());

  /// Monta a página dentro de um [MaterialApp] e aguarda a primeira frame.
  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailPage(product: sampleProduct),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ProductDetailPage — cabeçalho (Req 5.1)', () {
    testWidgets('exibe a imagem grande (hero)', (tester) async {
      await pumpPage(tester);

      // O hero usa Image.asset; sem asset real no ambiente de teste o
      // errorBuilder é acionado, então validamos a presença de um Image.
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('exibe o nome do produto', (tester) async {
      await pumpPage(tester);

      // Nome aparece no AppBar e no corpo.
      expect(find.text('Signature Lavender Latte'), findsWidgets);
    });

    testWidgets('exibe o preço formatado', (tester) async {
      await pumpPage(tester);

      expect(find.text('\$5.50'), findsOneWidget);
    });

    testWidgets('exibe as tags do produto', (tester) async {
      await pumpPage(tester);

      expect(find.text('Floral'), findsOneWidget);
      expect(find.text('Signature'), findsOneWidget);
    });

    testWidgets('exibe a descrição do produto', (tester) async {
      await pumpPage(tester);

      expect(
        find.text('Espresso encorpado com um toque floral de lavanda.'),
        findsOneWidget,
      );
    });
  });

  group('ProductDetailPage — seletores (Reqs 5.2, 5.3, 5.4)', () {
    testWidgets('seletor de tamanho mostra 8oz / 12oz / 16oz (Req 5.2)',
        (tester) async {
      await pumpPage(tester);

      expect(find.text('Size'), findsOneWidget);
      expect(find.text('8oz'), findsOneWidget);
      expect(find.text('12oz'), findsOneWidget);
      expect(find.text('16oz'), findsOneWidget);
    });

    testWidgets(
        'seletor de leite mostra Whole / Oat / Almond Milk (Req 5.3)',
        (tester) async {
      await pumpPage(tester);

      expect(find.text('Milk'), findsOneWidget);
      expect(find.text('Whole Milk'), findsOneWidget);
      expect(find.text('Oat Milk (+\$0.75)'), findsOneWidget);
      expect(find.text('Almond Milk (+\$0.75)'), findsOneWidget);
    });

    testWidgets('seletor de adoçamento mostra None / Light / Regular (Req 5.4)',
        (tester) async {
      await pumpPage(tester);

      expect(find.text('Sweetness'), findsOneWidget);
      expect(find.text('None'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Regular'), findsOneWidget);
    });
  });

  group('ProductDetailPage — seleções padrão (Reqs 5.2, 5.3, 5.4)', () {
    /// Retorna o [ChoiceChip] cujo rótulo é [label].
    ChoiceChip chipWithLabel(WidgetTester tester, String label) {
      final chipFinder = find.ancestor(
        of: find.text(label),
        matching: find.byType(ChoiceChip),
      );
      return tester.widget<ChoiceChip>(chipFinder);
    }

    testWidgets('tamanho padrão é 12oz selecionado (Req 5.2)', (tester) async {
      await pumpPage(tester);

      expect(chipWithLabel(tester, '12oz').selected, isTrue);
      expect(chipWithLabel(tester, '8oz').selected, isFalse);
      expect(chipWithLabel(tester, '16oz').selected, isFalse);
    });

    testWidgets('leite padrão é Whole Milk selecionado (Req 5.3)',
        (tester) async {
      await pumpPage(tester);

      expect(chipWithLabel(tester, 'Whole Milk').selected, isTrue);
      expect(chipWithLabel(tester, 'Oat Milk (+\$0.75)').selected, isFalse);
      expect(chipWithLabel(tester, 'Almond Milk (+\$0.75)').selected, isFalse);
    });

    testWidgets('adoçamento padrão é Regular selecionado (Req 5.4)',
        (tester) async {
      await pumpPage(tester);

      expect(chipWithLabel(tester, 'Regular').selected, isTrue);
      expect(chipWithLabel(tester, 'None').selected, isFalse);
      expect(chipWithLabel(tester, 'Light').selected, isFalse);
    });
  });
}
