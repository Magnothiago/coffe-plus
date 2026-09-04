/// Card de produto exibido na tela de Menu ("Explorar Sabores") — Reqs 4.3, 4.4.
///
/// Renderiza a imagem, o nome, a descrição, o preço formatado e um botão "+".
/// Quando [Product.featured] é verdadeiro, exibe um badge "FEATURED" sobre a
/// imagem (Req 4.4). Tocar no card dispara [onTap] (navegação para detalhes —
/// Req 4.6); tocar no botão "+" dispara [onAdd] (adicionar ao carrinho — Req
/// 4.7).
library;

import 'package:flutter/material.dart';

import '../../catalog/data/local_product_data_source.dart';
import '../../catalog/models/product.dart';

/// Formata um preço em centavos inteiros para exibição no padrão `$X.XX`.
String formatPriceCents(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

/// Decide se o badge "FEATURED" deve ser exibido para um [product] (Req 4.4).
///
/// Função pura e determinística: o badge aparece se e somente se
/// [Product.featured] é verdadeiro. Extraída da lógica de renderização do
/// [ProductCard] para permitir verificação por property test sem construir a
/// UI (ver Testing Strategy, Property 14).
bool shouldShowFeaturedBadge(Product product) => product.featured;

/// Card visual de um [Product] no Menu.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.imageResolver,
    required this.onTap,
    required this.onAdd,
  });

  /// Produto exibido no card.
  final Product product;

  /// Fonte de dados usada para resolver o caminho de imagem do produto (Req 7).
  final LocalProductDataSource imageResolver;

  /// Chamado quando o card é tocado (navega para detalhes — Req 4.6).
  final VoidCallback onTap;

  /// Chamado quando o botão "+" é tocado (adiciona ao carrinho — Req 4.7).
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String imagePath = imageResolver.resolveImagePath(product);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        // IntrinsicHeight dá à Row uma altura finita a partir dos filhos,
        // permitindo que CrossAxisAlignment.stretch funcione dentro de uma
        // lista de altura ilimitada (ListView).
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagem + badge FEATURED (Req 4.3, 4.4).
              SizedBox(
                width: 110,
                // Altura mínima da miniatura; a Row estica a coluna de imagem
                // para acompanhar a altura do conteúdo textual quando maior.
                height: 120,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      // Fallback com tamanho definido caso o asset não carregue
                      // (garante que o card tenha altura válida no layout).
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.local_cafe,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (shouldShowFeaturedBadge(product))
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FEATURED',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Conteúdo textual + ação (Req 4.3).
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            formatPriceCents(product.basePriceCents),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          // Botão "+" (Req 4.7).
                          IconButton.filled(
                            onPressed: onAdd,
                            icon: const Icon(Icons.add),
                            tooltip: 'Adicionar ao carrinho',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
