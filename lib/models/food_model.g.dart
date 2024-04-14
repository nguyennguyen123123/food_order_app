// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodModel _$FoodModelFromJson(Map<String, dynamic> json) => FoodModel(
      foodId: json['foodId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as double?,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
      foodType: json['typeId'] == null ? null : FoodType.fromJson(json['typeId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FoodModelToJson(FoodModel instance) => <String, dynamic>{
      'foodId': instance.foodId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image': instance.image,
      'typeId': instance.typeId,
      'created_at': instance.createdAt,
    };
