// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodType _$FoodTypeFromJson(Map<String, dynamic> json) => FoodType(
      typeId: json['typeId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      parentTypeId: json['parent_type_id'] as String?,
      order: json['order'] as int?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$FoodTypeToJson(FoodType instance) => <String, dynamic>{
      'typeId': instance.typeId,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'parent_type_id': instance.parentTypeId,
      'order': instance.order,
      'created_at': instance.createdAt,
    };
