/// Smoke test do app real ([MyApp]) — garante que a aplicação inicializa e
/// renderiza a tela inicial (fluxo de login) sem erros.
///
/// O template padrão do Flutter (contador) foi substituído porque o app agora
/// inicia na [LoginPage] via [AppRoutes], e não em uma UI de contador.
///
/// A [LoginPage] resolve a [LoginStore] via `getIt<LoginStore>()`, então o
/// teste registra as dependências com [configureDependencies] após um
/// `getIt.reset()` (idempotência entre execuções). Uma superfície alta é usada
/// para que todo o conteúdo do card de login caiba na tela.
library;

import 'package:coffe_plus/di/injection.dart';
import 'package:coffe_plus/features/login/pages/login_page.dart';
import 'package:coffe_plus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    configureDependencies();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('o app inicializa e renderiza a tela de login', (tester) async {
    // Superfície alta o suficiente para o conteúdo do card de login.
    tester.view.physicalSize = const Size(1080, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // O app entra no fluxo de login e exibe o título "The Sensory Pour".
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('The Sensory Pour'), findsOneWidget);
  });
}
