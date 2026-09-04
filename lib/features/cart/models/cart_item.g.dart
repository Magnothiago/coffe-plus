// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  product: Product.fromJson(json['product'] as Map<String, dynamic>),
  size: $enumDecode(_$SizeOptionEnumMap, json['size']),
  milk: $enumDecode(_$MilkOptionEnumMap, json['milk']),
  sweetness: $enumDecode(_$SweetnessOptionEnumMap, json['sweetness']),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'product': instance.product.toJson(),
  'size': _$SizeOptionEnumMap[instance.size]!,
  'milk': _$MilkOptionEnumMap[instance.milk]!,
  'sweetness': _$SweetnessOptionEnumMap[instance.sweetness]!,
  'quantity': instance.quantity,
};

const _$SizeOptionEnumMap = {
  SizeOption.oz8: 'oz8',
  SizeOption.oz12: 'oz12',
  SizeOption.oz16: 'oz16',
};

const _$MilkOptionEnumMap = {
  MilkOption.whole: 'whole',
  MilkOption.oat: 'oat',
  MilkOption.almond: 'almond',
};

const _$SweetnessOptionEnumMap = {
  SweetnessOption.none: 'none',
  SweetnessOption.light: 'light',
  SweetnessOption.regular: 'regular',
};
