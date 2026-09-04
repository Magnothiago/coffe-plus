/// Rotas nomeadas e navegação entre as telas do app "The Sensory Pour"
/// (Reqs 3.7, 4.6, 6.9).
///
/// As rotas mapeiam nomes constantes para páginas via [AppRoutes.onGenerateRoute],
/// consumido pelo `MaterialApp` em `main.dart`. A rota [productDetail] recebe um
/// [Product] em `settings.arguments`.
library;

import 'package:flutter/material.dart';

import '../../features/cart/pages/cart_page.dart';
import '../../features/catalog/models/product.dart';
import '../../features/login/pages/login_page.dart';
import '../../features/menu/pages/menu_page.dart';
import '../../features/product_detail/pages/product_detail_page.dart';

/// Definição centralizada das rotas nomeadas e do gerador de rotas do app.
class AppRoutes {
  const AppRoutes._();

  /// Rota da tela de Login (tela inicial).
  static const String login = '/login';

  /// Rota da tela de Menu / Explorar Sabores.
  static const String menu = '/menu';

  /// Rota da tela de Detalhes do Produto. Espera um [Product] como argumento.
  static const String productDetail = '/product-detail';

  /// Rota da tela do Carrinho.
  static const String cart = '/cart';

  /// Mapeia um nome de rota para a página correspondente.
  ///
  /// A rota [productDetail] valida que `settings.arguments` seja um [Product].
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LoginPage(),
        );

      case menu:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const MenuPage(),
        );

      case productDetail:
        final args = settings.arguments;
        if (args is! Product) {
          return _errorRoute(
            settings,
            'A rota $productDetail requer um Product em settings.arguments.',
          );
        }
        final product = args;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ProductDetailPage(product: product),
        );

      case cart:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CartPage(),
        );

      default:
        return _errorRoute(settings, 'Rota desconhecida: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings, String message) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro de navegação')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
