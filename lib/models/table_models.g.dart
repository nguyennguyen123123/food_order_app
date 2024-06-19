// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModels _$TableModelsFromJson(Map<String, dynamic> json) => TableModels(
      tableId: json['table_id'] as String?,
      tableNumber: json['table_number'] as String?,
      createdAt: json['created_at'] as String?,
      foodOrder: json['order'] != null && json['order'] is Map ? FoodOrder.fromJson(json['order']) : null,
      foodOrderId: json['order'] != null && json['order'] is String ? json['order'] : null,
      areaId: json['area_id'] == null
          ? null
          : json['area_id'] is String
              ? json['area_id'] as String? ?? ''
              : null,
      area: json['area_id'] == null
          ? null
          : json['area_id'] is Map
              ? Area.fromJson(json['area_id'])
              : null,
      hasOrder: json['has_order'] ?? false,
    );

Map<String, dynamic> _$TableModelsToJson(TableModels instance) => <String, dynamic>{
      'table_id': instance.tableId,
      'table_number': instance.tableNumber,
      'created_at': instance.createdAt,
      'area_id': instance.areaId,
      'order': null,
      'has_order': instance.hasOrder
    };
