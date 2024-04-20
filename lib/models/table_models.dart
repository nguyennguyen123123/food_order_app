// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_models.g.dart';

@JsonSerializable()
class TableModels {
  @JsonKey(name: 'table_id')
  String? tableId;
  @JsonKey(name: 'table_number') // số bàn
  String? tableNumber;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'order', includeToJson: false)
  FoodOrder? foodOrder;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? foodOrderId;
  @JsonKey(name: 'area_id')
  String? areaId;
  @JsonKey(includeToJson: false, includeFromJson: true, name: 'area_id')
  Area? area;

  TableModels({
    this.tableId,
    this.tableNumber,
    this.createdAt,
    this.foodOrder,
    this.foodOrderId,
    this.areaId,
    this.area,
  });

  Map<String, dynamic> toJson() => _$TableModelsToJson(this);

  Map toMap(TableModels tableModels) => _$TableModelsToJson(this);

  factory TableModels.fromJson(Map<String, dynamic> json) => _$TableModelsFromJson(json);
}
