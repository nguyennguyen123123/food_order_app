// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModels _$TableModelsFromJson(Map<String, dynamic> json) => TableModels(
      tableId: json['table_id'] as String?,
      tableNumber: json['table_number'] as String?,
      createdAt: json['created_at'] as String?,
      foodOrder: json['order'] == null
          ? null
          : FoodOrder.fromJson(json['order'] as Map<String, dynamic>),
      areaId: json['area_id'] as String?,
      area: json['area_id'] == null
          ? null
          : Area.fromJson(json['area_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TableModelsToJson(TableModels instance) =>
    <String, dynamic>{
      'table_id': instance.tableId,
      'table_number': instance.tableNumber,
      'created_at': instance.createdAt,
      'area_id': instance.areaId,
    };
