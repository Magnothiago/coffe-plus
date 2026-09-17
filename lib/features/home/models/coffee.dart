/// Item do cardápio retornado por `GET /home/coffees`.
library;

import 'package:json_annotation/json_annotation.dart';

part 'coffee.g.dart';

/// Café exibido na tela Home, conforme contrato do backend
/// (todos os campos são strings, incluindo [price] já formatado).
@JsonSerializable()
class Coffee {
  const Coffee({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) => _$CoffeeFromJson(json);

  final String id;
  final String title;
  final String description;
  final String price;

  Map<String, dynamic> toJson() => _$CoffeeToJson(this);
}
