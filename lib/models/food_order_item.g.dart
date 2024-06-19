// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodOrderItem _$FoodOrderItemFromJson(Map<String, dynamic> json) =>
    FoodOrderItem(
      id: json['id'] as int?,
      foodOrderId: json['food_order_id'] as String?,
      orderItemId: json['order_item_id'] as String?,
    );

Map<String, dynamic> _$FoodOrderItemToJson(FoodOrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'food_order_id': instance.foodOrderId,
      'order_item_id': instance.orderItemId,
    };
