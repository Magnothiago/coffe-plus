/// Widget tests da tela de Login ([LoginPage]) — Reqs 3.1, 3.2, 3.7, 3.8.
///
/// Verificam a renderização integrada da tela e a navegação para o Menu:
/// - Fundo (Image) + Card centrais presentes (Req 3.1).
/// - Título serifado "The Sensory Pour" presente (Req 3.2).
/// - Campos EMAIL ADDRESS / PASSWORD, toggle de olho e checkbox "Remember me".
/// - Links auxiliares, divisor "OR CONTINUE WITH", botões Google/Apple e
///   "Create an account" (Req 3.8).
/// - Com credenciais válidas, tocar SIGN IN navega para a rota do Menu, e com
///   credenciais inválidas permanece no Login (Req 3.7).
///
/// A [LoginPage] resolve a [LoginStore] via `getIt<LoginStore>()`, então cada
/// teste registra as dependências com [configureDependencies], após um
/// `getIt.reset()` para garantir idempotência entre execuções. A navegação usa
/// [AppRoutes.onGenerateRoute] para que a rota `/menu` seja resolvida pelo
/// mesmo gerador de rotas usado em produção.
library;

import 'package:coffe_plus/core/routing/app_routes.dart';
import 'package:coffe_plus/di/injection.dart';
import 'package:coffe_plus/features/login/pages/login_page.dart';
import 'package:coffe_plus/features/menu/pages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// [NavigatorObserver] de teste que registra os nomes das rotas empilhadas,
/// permitindo verificar a navegação sem depender da renderização completa da
/// tela de destino.
class _RouteRecorder extends NavigatorObserver {
  final List<String?> pushedRoutes = <String?>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route.settings.name);
    super.didPush(route, previousRoute);
  }
}

/// Envolve a [LoginPage] em um [MaterialApp] com o gerador de rotas real, de
/// modo que a navegação nomeada para `/menu` seja resolvida como em produção.
/// Um [observer] opcional captura os pushes de rota.
Widget _wrapLoginPage([NavigatorObserver? observer]) => MaterialApp(
      home: const LoginPage(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      navigatorObservers: observer != null ? <NavigatorObserver>[observer] : const [],
    );

/// Define uma janela de teste alta o suficiente para que todo o conteúdo do
/// card de login seja construído e caiba na tela.
void _useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2600);
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

  group('LoginPage — estrutura (Reqs 3.1, 3.2)', () {
    testWidgets('exibe o fundo (Image) e um Card central (Req 3.1)',
        (tester) async {
      _useTallSurface(tester);

      await tester.pumpWidget(_wrapLoginPage());
      await tester.pumpAndSettle();

      // Imagem de fundo (assets podem não decodificar no ambiente de teste, mas
      // o widget Image sempre é montado).
      expect(find.byType(Image), findsWidgets);
      // Card central sobreposto ao fundo.
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('exibe o título serifado "The Sensory Pour" (Req 3.2)',
        (tester) async {
      _useTallSurface(tester);

      await tester.pumpWidget(_wrapLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('The Sensory Pour'), findsOneWidget);
    });
  });

  group('LoginPage — campos e controles (Reqs 3.2, 3.3, 3.4)', () {
    testWidgets('exibe os campos EMAIL ADDRESS e PASSWORD', (tester) async {
      _useTallSurface(tester);

      await tester.pumpWidget(_wrapLoginPage());
      await tester.pumpAndSettle();

      // Campos identificados por key.
      expect(find.byKey(const Key('login_email_field')), findsOneWidget);
      expect(find.byKey(const Key('login_password_field')), findsOneWidget);
      // Rótulos dos campos.
      expect(find.text('EMAIL ADDRESS'), findsOneWidget);
      expect(find.text('PASSWORD'), findsOneWidget);
    });

    testWidgets('exibe o toggle de olho da senha (Req 3.3)', (tester) async {
      _useTallSurface(tester);

      await tester.pumpWidget(_wrapLoginPage());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('login_password_toggle')), findsOneWidget);
    });

    testWidgets('exibe o checkbox "Remember me" (Req 3.4)', (tester) async {
      _useTallSurface(tester);

      await tester.pumpWidget(_wrapLoginPage());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('login_remember_me')), findsOneWidget);
      expect(find.text('Remember me'), findsOneWidget);
    });
  });

  group('LoginPage — links e provedores sociais (Req 3.8)', () {
    testWidgets('exibe Forgot Password?, divisor, Google/Apple e Create account',
        (tester) async {
      _useTallSurface(tester);

      await tester.pumpWidget(_wrapLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('OR CONTINUE WITH'), findsOneWidget);
      expect(find.byKey(const Key('login_google_button')), findsOneWidget);
      expect(find.byKey(const Key('login_apple_button')), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Create an account'), findsOneWidget);
    });
  });

  group('LoginPage — navegação (Req 3.7)', () {
    testWidgets(
        'com credenciais válidas, SIGN IN navega para o Menu',
        (tester) async {
      _useTallSurface(tester);

      final observer = _RouteRecorder();
      await tester.pumpWidget(_wrapLoginPage(observer));
      await tester.pumpAndSettle();

      // Preenche email válido e senha não vazia.
      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'user@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'secret123',
      );
      await tester.pumpAndSettle();

      // Toca em SIGN IN. O push da rota nomeada ocorre de forma síncrona ao
      // tratar o toque, então o observer registra a navegação sem que uma nova
      // frame precise ser desenhada (evitando exercitar o layout da tela de
      // destino).
      await tester.tap(find.byKey(const Key('login_sign_in_button')));

      // A rota nomeada do Menu foi empilhada (Req 3.7). O gerador de rotas real
      // (AppRoutes.onGenerateRoute) mapeia essa rota para a MenuPage.
      expect(observer.pushedRoutes, contains(AppRoutes.menu));
      expect(
        AppRoutes.onGenerateRoute(
          const RouteSettings(name: AppRoutes.menu),
        ),
        isA<MaterialPageRoute<void>>(),
      );
    });

    testWidgets(
        'com email inválido, SIGN IN não navega e mantém a LoginPage',
        (tester) async {
      _useTallSurface(tester);

      final observer = _RouteRecorder();
      await tester.pumpWidget(_wrapLoginPage(observer));
      await tester.pumpAndSettle();

      // Registra apenas o push inicial da rota `home` (nome nulo).
      final int pushesBeforeTap = observer.pushedRoutes.length;

      // Email inválido (sem @) e senha não vazia.
      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'not-an-email',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'secret123',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('login_sign_in_button')));
      await tester.pumpAndSettle();

      // Permanece no Login: nenhuma rota nova foi empilhada e a MenuPage não é
      // exibida.
      expect(observer.pushedRoutes.length, pushesBeforeTap);
      expect(observer.pushedRoutes, isNot(contains(AppRoutes.menu)));
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(MenuPage), findsNothing);
    });
  });
}
