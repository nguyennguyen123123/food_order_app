// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModels _$TableModelsFromJson(Map<String, dynamic> json) => TableModels(
      tableId: json['table_id'] as String?,
      tableNumber: json['table_number'] as int?,
      numberOfOrder: json['number_of_order'] as int?,
      numberOfPeople: json['number_of_people'] as int?,
      createdAt: json['created_at'] as String?,
      foodOrder: json['order'] != null && json['order'] is Map ? FoodOrder.fromJson(json['order']) : null,
      foodOrderId: json['order'] != null && json['order'] is String ? json['order'] : null,
    );

Map<String, dynamic> _$TableModelsToJson(TableModels instance) => <String, dynamic>{
      'table_id': instance.tableId,
      'table_number': instance.tableNumber,
      'number_of_order': instance.numberOfOrder,
      'number_of_people': instance.numberOfPeople,
      'created_at': instance.createdAt,
    };
