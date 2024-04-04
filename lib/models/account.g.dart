// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['id'] as int?,
      createdAt: json['created_at'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'email': instance.email,
      'role': instance.role,
      'name': instance.name,
      'gender': instance.gender,
      'user_id': instance.userId,
    };
