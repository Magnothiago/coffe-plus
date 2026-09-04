/// Tela de Menu ("Explorar Sabores") — Reqs 4.1, 4.2, 4.3, 4.4, 4.6, 4.7, 4.8,
/// 4.9.
///
/// Exibe uma app bar (menu, título "The Sensory Pour", avatar), os filtros de
/// [Category], a lista reativa de produtos filtrados em [ProductCard]s e a
/// Bottom_Nav. Consome a [MenuStore] (categoria selecionada + produtos
/// filtrados) e a [CartStore] (adicionar produto com opções padrão), ambas
/// resolvidas via GetIt. Trechos reativos são envolvidos em [Observer].
library;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/routing/app_routes.dart';
import '../../../di/injection.dart';
import '../../cart/stores/cart_store.dart';
import '../../catalog/data/local_product_data_source.dart';
import '../../catalog/models/category.dart';
import '../../catalog/models/product.dart';
import '../stores/menu_store.dart';
import '../widgets/product_card.dart';

/// Página do Menu / Explorar Sabores.
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final MenuStore _menuStore = getIt<MenuStore>();
  late final CartStore _cartStore = getIt<CartStore>();
  late final LocalProductDataSource _dataSource =
      getIt<LocalProductDataSource>();

  static const int _menuNavIndex = 1;

  /// Rótulos amigáveis exibidos nos filtros de categoria (Req 4.2).
  static const Map<Category, String> _categoryLabels = {
    Category.espresso: 'Espresso',
    Category.brewed: 'Brewed',
    Category.coldBrew: 'Cold Brew',
  };

  void _onProductTap(Product product) {
    Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: product,
    );
  }

  void _onAdd(Product product) {
    _cartStore.addProductWithDefaults(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} adicionado ao carrinho'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _onNavTap(int index) {
    if (index == _menuNavIndex) {
      return;
    }
    // Cart taps navegam para a tela de Carrinho (Req 4.8).
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.cart);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      // App bar: menu, título, avatar (Req 4.1).
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
          tooltip: 'Menu',
        ),
        title: const Text('The Sensory Pour'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/home.jpeg'),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtros de Category (Reqs 4.2, 4.5).
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Observer(
              builder: (_) {
                final Category selected = _menuStore.selectedCategory;
                return Wrap(
                  spacing: 8,
                  children: Category.values.map((category) {
                    return ChoiceChip(
                      label: Text(_categoryLabels[category] ?? category.name),
                      selected: selected == category,
                      onSelected: (_) => _menuStore.selectCategory(category),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          // Lista de produtos filtrados (Reqs 4.3, 4.4, 4.9).
          Expanded(
            child: Observer(
              builder: (_) {
                final products = _menuStore.filteredProducts;
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum produto nesta categoria.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      imageResolver: _dataSource,
                      onTap: () => _onProductTap(product),
                      onAdd: () => _onAdd(product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Bottom_Nav: Home, Menu, Cart, Profile (Req 4.8).
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _menuNavIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe_outlined),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
