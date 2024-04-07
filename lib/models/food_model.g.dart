// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodModel _$FoodModelFromJson(Map<String, dynamic> json) => FoodModel(
      foodId: json['foodId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as int?,
      image: json['image'] as String?,
      createdAt: json['createdAt'] as String?,
      foodType: json['typeId'] == null ? null : FoodType.fromJson(json['typeId'] as Map<String, dynamic>),
      typeId: json['typeId'] == null ? null : json['typeId']['typeId'],
    );

Map<String, dynamic> _$FoodModelToJson(FoodModel instance) => <String, dynamic>{
      'foodId': instance.foodId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image': instance.image,
      'typeId': instance.typeId,
      'createdAt': instance.createdAt,
    };
