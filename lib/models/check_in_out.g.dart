// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInOut _$CheckInOutFromJson(Map<String, dynamic> json) => CheckInOut(
      id: json['id'] as int?,
      userId: json['user_id'] as String?,
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      totalOrders: json['total_orders'] as int?,
    );

Map<String, dynamic> _$CheckInOutToJson(CheckInOut instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'check_in_time': instance.checkInTime,
      'check_out_time': instance.checkOutTime,
      'total_orders': instance.totalOrders,
    };
