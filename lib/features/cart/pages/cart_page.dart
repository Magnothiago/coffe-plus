/// Tela do Carrinho de Compras ("Your Cart") — Req 6.
///
/// Renderiza a lista reativa de [CartItem]s (via [CartLine]), o Order Summary
/// (Subtotal/Tax/Total), o campo de Promo_Code com botão "APPLY" e mensagem de
/// erro, o botão "ADD ANOTHER ITEM" (navega para o Menu), o botão
/// "PROCEED TO CHECKOUT" (desabilitado quando o carrinho está vazio), um aviso
/// informativo e a Bottom_Nav (Home/Menu/Cart/Profile).
///
/// O estado é lido do [CartStore] resolvido via GetIt; as partes reativas são
/// envolvidas em [Observer] para reagirem às mudanças observáveis do store.
library;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../di/injection.dart';
import '../stores/cart_store.dart';
import '../widgets/cart_line.dart';

/// Formata um valor em centavos inteiros para exibição monetária (`$X.XX`).
String _formatCents(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

/// Página "Your Cart".
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartStore _cartStore = getIt<CartStore>();
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    FocusScope.of(context).unfocus();
    _cartStore.applyPromo(_promoController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            if (_cartStore.isEmpty) {
              return _buildBody(
                context,
                listSlivers: const [_EmptyCartMessage()],
              );
            }

            return _buildBody(
              context,
              listSlivers: [
                for (int i = 0; i < _cartStore.items.length; i++)
                  CartLine(
                    item: _cartStore.items[i],
                    onIncrement: () => _cartStore.updateQuantity(
                      i,
                      _cartStore.items[i].quantity + 1,
                    ),
                    onDecrement: () => _cartStore.updateQuantity(
                      i,
                      _cartStore.items[i].quantity - 1,
                    ),
                    onRemove: () => _cartStore.removeItem(i),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.menu);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.local_cafe_outlined), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required List<Widget> listSlivers,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...listSlivers,
        const SizedBox(height: 16),
        _PromoField(
          controller: _promoController,
          onApply: _applyPromo,
          errorText: _cartStore.promoError,
        ),
        const SizedBox(height: 16),
        _OrderSummary(
          subtotalCents: _cartStore.subtotalCents,
          taxCents: _cartStore.taxCents,
          totalCents: _cartStore.totalCents,
          discountCents: _cartStore.appliedDiscountCents,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.menu),
          icon: const Icon(Icons.add),
          label: const Text('ADD ANOTHER ITEM'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.coffeeBrown,
            side: const BorderSide(color: AppTheme.coffeeBrown),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _cartStore.isEmpty
                ? null
                : () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Checkout ainda não implementado.'),
                      ),
                    ),
            child: const Text('PROCEED TO CHECKOUT'),
          ),
        ),
        const SizedBox(height: 16),
        const _CartNotice(),
      ],
    );
  }
}

/// Mensagem exibida quando o carrinho está vazio.
class _EmptyCartMessage extends StatelessWidget {
  const _EmptyCartMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 48,
            color: AppTheme.caramel,
          ),
          const SizedBox(height: 12),
          Text(
            'Your cart is empty.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

/// Campo de Promo_Code com botão "APPLY" e mensagem de erro — Reqs 6.6, 6.7.
class _PromoField extends StatelessWidget {
  const _PromoField({
    required this.controller,
    required this.onApply,
    required this.errorText,
  });

  final TextEditingController controller;
  final VoidCallback onApply;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onApply(),
            decoration: InputDecoration(
              labelText: 'Promo Code',
              hintText: 'Enter promo code',
              errorText: errorText,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: ElevatedButton(
            onPressed: onApply,
            child: const Text('APPLY'),
          ),
        ),
      ],
    );
  }
}

/// Card do Order Summary com Subtotal, Tax e Total — Req 6.5.
class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.subtotalCents,
    required this.taxCents,
    required this.totalCents,
    required this.discountCents,
  });

  final int subtotalCents;
  final int taxCents;
  final int totalCents;
  final int discountCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Order Summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _SummaryRow(label: 'Subtotal', value: _formatCents(subtotalCents)),
            const SizedBox(height: 8),
            _SummaryRow(label: 'Tax', value: _formatCents(taxCents)),
            if (discountCents > 0) ...[
              const SizedBox(height: 8),
              _SummaryRow(
                label: 'Discount',
                value: '-${_formatCents(discountCents)}',
              ),
            ],
            const Divider(height: 24),
            _SummaryRow(
              label: 'Total',
              value: _formatCents(totalCents),
              emphasize: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Linha rotulada de valor dentro do Order Summary.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasize
        ? theme.textTheme.titleLarge
        : theme.textTheme.bodyLarge?.copyWith(color: AppTheme.espressoDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

/// Aviso informativo exibido na tela de Carrinho — Req 6.9.
class _CartNotice extends StatelessWidget {
  const _CartNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.caramel.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppTheme.coffeeBrown, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Prices include applicable taxes. Orders are prepared fresh and '
              'cannot be modified after checkout.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.espressoDark,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
