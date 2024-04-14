// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartyOrder _$PartyOrderFromJson(Map<String, dynamic> json) => PartyOrder(
      partyOrderId: json['party_order_id'] as String?,
      voucherPrice: (json['voucher_price'] as num?)?.toDouble(),
      total: (json['total_price'] as num?)?.toDouble(),
      orderStatus: json['order_status'] as String?,
      orderId: json['order_id'] as String?,
      createdAt: json['created_at'] as String?,
      partyNumber: json['party_number'] as int?,
      orderItems: (json['party_order_item'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e['order_item'] as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PartyOrderToJson(PartyOrder instance) => <String, dynamic>{
      'party_order_id': instance.partyOrderId,
      'voucher_price': instance.voucherPrice,
      'total_price': instance.total,
      'order_status': instance.orderStatus,
      'order_id': instance.orderId,
      'party_number': instance.partyNumber,
    };
