// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInOut _$CheckInOutFromJson(Map<String, dynamic> json) => CheckInOut(
      id: json['id'] as int?,
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      totalOrders: json['total_orders'] as int?,
      users: json['user_id'] == null ? null : Account.fromJson(json['user_id'] as Map<String, dynamic>),
      totalPrice: (json['total_price'] as num? ?? 0).toDouble(),
    );

Map<String, dynamic> _$CheckInOutToJson(CheckInOut instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'check_in_time': instance.checkInTime,
      'check_out_time': instance.checkOutTime,
      'total_orders': instance.totalOrders,
      'total_price': instance.totalPrice,
    };
