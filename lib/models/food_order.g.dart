// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodOrder _$FoodOrderFromJson(Map<String, dynamic> json) => FoodOrder(
      orderId: json['order_id'] as String?,
      orderItems: (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      voucherPrice: (json['voucher_price'] as num?)?.toDouble(),
      tableNumber: json['table_number'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      userOrder: json['user_order_id'] == null
          ? null
          : Account.fromJson(json['user_order_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FoodOrderToJson(FoodOrder instance) => <String, dynamic>{
      'order_id': instance.orderId,
      'order_items': instance.orderItemsId,
      'voucher_price': instance.voucherPrice,
      'table_number': instance.tableNumber,
      'total': instance.total,
      'user_order_id': instance.userOrderId,
    };
