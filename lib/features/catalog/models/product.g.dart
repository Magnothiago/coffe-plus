// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  basePriceCents: (json['basePriceCents'] as num).toInt(),
  imagePath: json['imagePath'] as String,
  category: $enumDecode(_$CategoryEnumMap, json['category']),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  featured: json['featured'] as bool? ?? false,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'basePriceCents': instance.basePriceCents,
  'imagePath': instance.imagePath,
  'category': _$CategoryEnumMap[instance.category]!,
  'tags': instance.tags,
  'featured': instance.featured,
};

const _$CategoryEnumMap = {
  Category.espresso: 'espresso',
  Category.brewed: 'brewed',
  Category.coldBrew: 'coldBrew',
};
