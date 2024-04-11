// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) => Table(
      tableId: json['table_id'] as String?,
      tableNumber: json['table_number'] as int?,
      numberOfOrder: json['number_of_order '] as int?,
      numberOfPeople: json['number_of_people '] as int?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
      'table_id': instance.tableId,
      'table_number': instance.tableNumber,
      'number_of_order ': instance.numberOfOrder,
      'number_of_people ': instance.numberOfPeople,
      'created_at': instance.createdAt,
    };
