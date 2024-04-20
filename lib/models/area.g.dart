// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Area _$AreaFromJson(Map<String, dynamic> json) => Area(
      areaId: json['area_id'] as String?,
      areaName: json['area_name'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'area_id': instance.areaId,
      'area_name': instance.areaName,
      'created_at': instance.createdAt,
    };
