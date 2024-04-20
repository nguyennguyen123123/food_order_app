import 'package:json_annotation/json_annotation.dart';

part 'area.g.dart';

@JsonSerializable()
class Area {
  @JsonKey(name: 'area_id')
  final String? areaId;
  @JsonKey(name: 'area_name')
  final String? areaName;
  @JsonKey(name: 'created_at')
  String? createdAt;

  Area({
    this.areaId,
    this.areaName,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => _$AreaToJson(this);

  Map toMap(Area area) => _$AreaToJson(this);

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);
}
