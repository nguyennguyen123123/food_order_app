// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      createdAt: json['created_at'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      userId: json['user_id'] as String?,
      checkInTime: json['check_in_time'] as String?,
      numberOfOrder: json['number_of_order'] as int?,
      totalOrderPrice: (json['total_order_price'] as num? ?? 0.0).toDouble(),
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'created_at': instance.createdAt,
      'email': instance.email,
      'role': instance.role,
      'name': instance.name,
      'gender': instance.gender,
      'user_id': instance.userId,
      'check_in_time': instance.checkInTime,
      'number_of_order': instance.numberOfOrder,
      'total_order_price': instance.totalOrderPrice,
    };
