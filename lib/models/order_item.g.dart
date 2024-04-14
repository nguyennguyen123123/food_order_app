// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      orderItemId: json['order_item_id'] as String?,
      food: json['food_id'] == null
          ? null
          : FoodModel.fromJson(json['food_id'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      note: json['note'] as String?,
      sortOder: json['sort_order'] as int?,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'order_item_id': instance.orderItemId,
      'food_id': instance.foodId,
      'quantity': instance.quantity,
      'note': instance.note,
      'sort_order': instance.sortOder,
    };
