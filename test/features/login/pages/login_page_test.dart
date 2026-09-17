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

import 'package:coffe_plus/core/network/api_exception.dart';
import 'package:coffe_plus/core/routing/app_routes.dart';
import 'package:coffe_plus/di/injection.dart';
import 'package:coffe_plus/features/home/data/home_repository.dart';
import 'package:coffe_plus/features/home/models/coffee.dart';
import 'package:coffe_plus/features/home/pages/home_page.dart';
import 'package:coffe_plus/features/login/data/auth_repository.dart';
import 'package:coffe_plus/features/login/pages/login_page.dart';
import 'package:coffe_plus/features/menu/pages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dublê de [AuthRepository] usado nos testes de widget, evitando chamadas de
/// rede reais. [succeeds] controla se o login é aceito ou rejeitado (401).
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.succeeds = true});

  final bool succeeds;

  @override
  Future<String> login({required String login, required String senha}) async {
    if (!succeeds) throw const UnauthorizedException();
    return 'fake-jwt-token';
  }
}

/// Substitui o [AuthRepository] real por um dublê no [getIt], evitando
/// chamadas de rede reais nos testes de widget da [LoginPage].
void _registerFakeAuthRepository({bool succeeds = true}) {
  if (getIt.isRegistered<AuthRepository>()) {
    getIt.unregister<AuthRepository>();
  }
  getIt.registerLazySingleton<AuthRepository>(
    () => _FakeAuthRepository(succeeds: succeeds),
  );
}

/// Dublê de [HomeRepository] usado nos testes de widget, evitando chamadas de
/// rede reais quando a navegação alcança a [HomePage].
class _FakeHomeRepository implements HomeRepository {
  const _FakeHomeRepository();

  @override
  Future<List<Coffee>> getCoffees() async => const [];
}

/// Substitui o [HomeRepository] real por um dublê no [getIt].
void _registerFakeHomeRepository() {
  if (getIt.isRegistered<HomeRepository>()) {
    getIt.unregister<HomeRepository>();
  }
  getIt.registerLazySingleton<HomeRepository>(
    () => const _FakeHomeRepository(),
  );
}

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

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    pushedRoutes.add(newRoute?.settings.name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

/// Envolve a [LoginPage] em um [MaterialApp] com o gerador de rotas real, de
/// modo que a navegação nomeada para `/menu` seja resolvida como em produção.
/// Um [observer] opcional captura os pushes de rota.
Widget _wrapLoginPage([NavigatorObserver? observer]) => MaterialApp(
  home: const LoginPage(),
  onGenerateRoute: AppRoutes.onGenerateRoute,
  navigatorObservers: observer != null
      ? <NavigatorObserver>[observer]
      : const [],
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
    _registerFakeAuthRepository();
    _registerFakeHomeRepository();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('LoginPage — estrutura (Reqs 3.1, 3.2)', () {
    testWidgets('exibe o fundo (Image) e um Card central (Req 3.1)', (
      tester,
    ) async {
      _useTallSurface(tester);

      await tester.pumpWidget(_wrapLoginPage());
      await tester.pumpAndSettle();

      // Imagem de fundo (assets podem não decodificar no ambiente de teste, mas
      // o widget Image sempre é montado).
      expect(find.byType(Image), findsWidgets);
      // Card central sobreposto ao fundo.
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('exibe o título serifado "The Sensory Pour" (Req 3.2)', (
      tester,
    ) async {
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
    testWidgets(
      'exibe Forgot Password?, divisor, Google/Apple e Create account',
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
      },
    );
  });

  group('LoginPage — navegação (Req 3.7)', () {
    testWidgets('com credenciais válidas, SIGN IN navega para a Home', (
      tester,
    ) async {
      _useTallSurface(tester);
      _registerFakeAuthRepository(succeeds: true);

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

      // Toca em SIGN IN; o login é assíncrono (dublê de AuthRepository), logo
      // aguardamos o pumpAndSettle para a navegação ocorrer.
      await tester.tap(find.byKey(const Key('login_sign_in_button')));
      await tester.pumpAndSettle();

      // A rota nomeada da Home foi empilhada (Req 3.7).
      expect(observer.pushedRoutes, contains(AppRoutes.home));
      expect(
        AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.home)),
        isA<MaterialPageRoute<void>>(),
      );
    });

    testWidgets('com email inválido, SIGN IN não navega e mantém a LoginPage', (
      tester,
    ) async {
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

    testWidgets(
      'com credenciais rejeitadas pelo backend (401), SIGN IN não navega e '
      'exibe mensagem de erro',
      (tester) async {
        _useTallSurface(tester);
        _registerFakeAuthRepository(succeeds: false);

        final observer = _RouteRecorder();
        await tester.pumpWidget(_wrapLoginPage(observer));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('login_email_field')),
          'user@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('login_password_field')),
          'wrong-password',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('login_sign_in_button')));
        await tester.pumpAndSettle();

        expect(observer.pushedRoutes, isNot(contains(AppRoutes.home)));
        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.text('Login ou senha inválidos.'), findsOneWidget);
      },
    );
  });
}
