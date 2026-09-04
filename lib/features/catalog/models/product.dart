/// Modelo de dados de um item do cardápio (Reqs 2.1, 2.3, 2.5).
///
/// O preço é expresso em centavos inteiros ([basePriceCents]) para evitar erros
/// de arredondamento de ponto flutuante nos cálculos monetários. A conversão
/// para exibição (ex.: `$5.50`) ocorre apenas na camada de formatação.
library;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:json_annotation/json_annotation.dart';

import 'category.dart';

part 'product.g.dart';

/// Produto do catálogo serializável de/para JSON.
///
/// Os campos obrigatórios ([id], [name], [description], [basePriceCents],
/// [imagePath], [category]) não possuem valor default, portanto
/// [_$ProductFromJson] lança quando algum deles está ausente no JSON (Req 2.5).
///
/// A igualdade é por valor sobre todos os campos (incluindo a lista [tags]),
/// garantindo a propriedade de round-trip `Product.fromJson(p.toJson()) == p`
/// (Req 2.3).
@JsonSerializable()
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.basePriceCents,
    required this.imagePath,
    required this.category,
    this.tags = const [],
    this.featured = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Identificador único do produto.
  final String id;

  /// Nome exibido do produto.
  final String name;

  /// Descrição textual do produto.
  final String description;

  /// Preço base em centavos inteiros (ex.: 550 => $5.50).
  final int basePriceCents;

  /// Caminho do asset de imagem em `assets/images/`.
  final String imagePath;

  /// Categoria/classificação do produto.
  final Category category;

  /// Tags descritivas (opcional; default lista vazia).
  final List<String> tags;

  /// Indicador de destaque "featured" (opcional; default `false`).
  final bool featured;

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          basePriceCents == other.basePriceCents &&
          imagePath == other.imagePath &&
          category == other.category &&
          listEquals(tags, other.tags) &&
          featured == other.featured;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        basePriceCents,
        imagePath,
        category,
        Object.hashAll(tags),
        featured,
      );
}
