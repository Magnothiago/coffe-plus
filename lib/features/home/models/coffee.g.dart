// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coffee _$CoffeeFromJson(Map<String, dynamic> json) => Coffee(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  price: json['price'] as String,
);

Map<String, dynamic> _$CoffeeToJson(Coffee instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'price': instance.price,
};
