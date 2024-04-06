// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      food: json['food'] == null
          ? null
          : FoodModel.fromJson(json['food'] as Map<String, dynamic>),
      foodId: json['food_id'] as String?,
      quantity: json['quantity'] as int?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'food': instance.food,
      'food_id': instance.foodId,
      'quantity': instance.quantity,
      'note': instance.note,
    };
