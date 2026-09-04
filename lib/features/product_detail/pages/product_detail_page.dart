/// Tela de Detalhes do Produto ("Product Detail") — Reqs 5.1–5.9.
///
/// Exibe a imagem grande (hero), nome, preço, tags e descrição do [Product],
/// além dos seletores de tamanho, leite e adoçamento, o controle de quantidade
/// e o botão "ADD TO CART" com o total calculado. As partes reativas observam a
/// [ProductDetailStore] via [Observer]; ao adicionar ao carrinho, delega à
/// [CartStore] e retorna à tela anterior.
library;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/theme/app_theme.dart';
import '../../../di/injection.dart';
import '../../cart/stores/cart_store.dart';
import '../../catalog/models/options.dart';
import '../../catalog/models/product.dart';
import '../stores/product_detail_store.dart';

/// Formata um valor em centavos inteiros como `$X.XX`.
String _formatCents(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

/// Página de detalhes de um [Product], recebido via construtor.
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  /// Produto exibido nesta tela.
  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductDetailStore _store;
  late final CartStore _cartStore;

  @override
  void initState() {
    super.initState();
    _store = getIt<ProductDetailStore>(param1: widget.product);
    _cartStore = getIt<CartStore>();
  }

  void _addToCart() {
    _cartStore.addItem(_store.buildCartItem());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _buildHero(product),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    _formatCents(product.basePriceCents),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.coffeeBrown,
                    ),
                  ),
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildTags(product),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildSizeSelector(),
                  const SizedBox(height: 24),
                  _buildMilkSelector(),
                  const SizedBox(height: 24),
                  _buildSweetnessSelector(),
                  const SizedBox(height: 24),
                  _buildQuantityControl(),
                  const SizedBox(height: 24),
                  _buildAddToCartButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Imagem grande do produto (hero) — Req 5.1.
  Widget _buildHero(Product product) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Image.asset(
        product.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppTheme.caramel,
          alignment: Alignment.center,
          child: const Icon(
            Icons.local_cafe,
            size: 64,
            color: AppTheme.espressoDark,
          ),
        ),
      ),
    );
  }

  /// Chips das tags do produto — Req 5.1.
  Widget _buildTags(Product product) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final String tag in product.tags)
          Chip(
            label: Text(tag),
            backgroundColor: AppTheme.creamSurface,
            side: const BorderSide(color: AppTheme.caramel),
          ),
      ],
    );
  }

  /// Seletor de tamanho (8oz / 12oz / 16oz), padrão 12oz — Req 5.2.
  Widget _buildSizeSelector() {
    const Map<SizeOption, String> labels = {
      SizeOption.oz8: '8oz',
      SizeOption.oz12: '12oz',
      SizeOption.oz16: '16oz',
    };
    return _buildSection(
      title: 'Size',
      child: Observer(
        builder: (_) => Row(
          children: [
            for (final SizeOption option in SizeOption.values)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _ChoiceChipButton(
                  label: labels[option]!,
                  selected: _store.size == option,
                  onTap: () => _store.selectSize(option),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Seletor de leite: Whole (padrão), Oat (+$0.75), Almond (+$0.75) — Req 5.3.
  Widget _buildMilkSelector() {
    const Map<MilkOption, String> labels = {
      MilkOption.whole: 'Whole Milk',
      MilkOption.oat: 'Oat Milk',
      MilkOption.almond: 'Almond Milk',
    };
    return _buildSection(
      title: 'Milk',
      child: Observer(
        builder: (_) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final MilkOption option in MilkOption.values)
              _ChoiceChipButton(
                label: option.surchargeCents > 0
                    ? '${labels[option]!} (+${_formatCents(option.surchargeCents)})'
                    : labels[option]!,
                selected: _store.milk == option,
                onTap: () => _store.selectMilk(option),
              ),
          ],
        ),
      ),
    );
  }

  /// Seletor de adoçamento: None / Light / Regular — Req 5.4.
  Widget _buildSweetnessSelector() {
    const Map<SweetnessOption, String> labels = {
      SweetnessOption.none: 'None',
      SweetnessOption.light: 'Light',
      SweetnessOption.regular: 'Regular',
    };
    return _buildSection(
      title: 'Sweetness',
      child: Observer(
        builder: (_) => Row(
          children: [
            for (final SweetnessOption option in SweetnessOption.values)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _ChoiceChipButton(
                  label: labels[option]!,
                  selected: _store.sweetness == option,
                  onTap: () => _store.selectSweetness(option),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Controle de incremento/decremento da quantidade (piso 1) — Reqs 5.6, 5.7.
  Widget _buildQuantityControl() {
    return _buildSection(
      title: 'Quantity',
      child: Row(
        children: [
          IconButton.outlined(
            onPressed: _store.decrement,
            icon: const Icon(Icons.remove),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Observer(
              builder: (_) => Text(
                '${_store.quantity}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          IconButton.outlined(
            onPressed: _store.increment,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  /// Botão "ADD TO CART" exibindo o total (unitário × quantidade) — Reqs 5.8, 5.9.
  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      child: Observer(
        builder: (_) => ElevatedButton(
          onPressed: _addToCart,
          child: Text('ADD TO CART  •  ${_formatCents(_store.totalPriceCents)}'),
        ),
      ),
    );
  }

  /// Envolve um seletor com um título de seção.
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

/// Botão de escolha estilizado usado nos seletores de opção.
class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.coffeeBrown,
      backgroundColor: AppTheme.creamSurface,
      side: const BorderSide(color: AppTheme.caramel),
      labelStyle: TextStyle(
        color: selected ? AppTheme.cream : AppTheme.espressoDark,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
