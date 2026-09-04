/// Widget de uma linha de item do Carrinho ("Your Cart") — Reqs 6.1, 6.2, 6.3.
///
/// Exibe a imagem do produto, o nome, as opções selecionadas
/// (tamanho/leite/adoçamento), o preço da linha ([CartItem.lineTotalCents]),
/// um controle de quantidade e uma ação de remover. As interações são
/// delegadas via callbacks para que o widget permaneça sem estado próprio; o
/// [CartStore] permanece a única fonte de verdade.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../catalog/models/options.dart';
import '../models/cart_item.dart';

/// Formata um valor em centavos inteiros para exibição monetária (`$X.XX`).
String _formatCents(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

/// Rótulo curto para um [SizeOption].
String _sizeLabel(SizeOption size) {
  switch (size) {
    case SizeOption.oz8:
      return '8oz';
    case SizeOption.oz12:
      return '12oz';
    case SizeOption.oz16:
      return '16oz';
  }
}

/// Rótulo curto para um [MilkOption].
String _milkLabel(MilkOption milk) {
  switch (milk) {
    case MilkOption.whole:
      return 'Whole Milk';
    case MilkOption.oat:
      return 'Oat Milk';
    case MilkOption.almond:
      return 'Almond Milk';
  }
}

/// Rótulo curto para um [SweetnessOption].
String _sweetnessLabel(SweetnessOption sweetness) {
  switch (sweetness) {
    case SweetnessOption.none:
      return 'No Sugar';
    case SweetnessOption.light:
      return 'Light';
    case SweetnessOption.regular:
      return 'Regular';
  }
}

/// Linha de item do carrinho.
class CartLine extends StatelessWidget {
  const CartLine({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  /// Item exibido nesta linha.
  final CartItem item;

  /// Chamado ao tocar em "+" (incrementar quantidade).
  final VoidCallback onIncrement;

  /// Chamado ao tocar em "-" (decrementar quantidade).
  final VoidCallback onDecrement;

  /// Chamado ao tocar na ação de remover.
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final optionsLabel =
        '${_sizeLabel(item.size)} · ${_milkLabel(item.milk)} · ${_sweetnessLabel(item.sweetness)}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.product.imagePath,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72,
                  height: 72,
                  color: AppTheme.caramel.withValues(alpha: 0.3),
                  child: const Icon(Icons.local_cafe, color: AppTheme.coffeeBrown),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: onRemove,
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Remover item',
                        color: AppTheme.espressoDark,
                      ),
                    ],
                  ),
                  Text(
                    optionsLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.coffeeBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatCents(item.lineTotalCents),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.espressoDark,
                        ),
                      ),
                      _QuantityControl(
                        quantity: item.quantity,
                        onIncrement: onIncrement,
                        onDecrement: onDecrement,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Controle de quantidade com botões de "-" e "+" e o valor atual.
class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.caramel),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove),
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            tooltip: 'Diminuir quantidade',
            color: AppTheme.coffeeBrown,
          ),
          Text(
            '$quantity',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppTheme.espressoDark),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add),
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            tooltip: 'Aumentar quantidade',
            color: AppTheme.coffeeBrown,
          ),
        ],
      ),
    );
  }
}
