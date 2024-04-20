// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  TableModels({
    this.tableId,
    this.tableNumber,
    this.createdAt,
    this.foodOrder,
    this.foodOrderId,
  });

  Map<String, dynamic> toJson() => _$TableModelsToJson(this);

  Map toMap(TableModels tableModels) => _$TableModelsToJson(this);

  factory TableModels.fromJson(Map<String, dynamic> json) => _$TableModelsFromJson(json);

  TableModels copyWith({
    String? tableId,
    String? tableNumber,
    String? createdAt,
    FoodOrder? foodOrder,
    String? foodOrderId,
  }) {
    return TableModels(
      tableId: tableId ?? this.tableId,
      tableNumber: tableNumber ?? this.tableNumber,
      createdAt: createdAt ?? this.createdAt,
      foodOrder: foodOrder ?? this.foodOrder,
      foodOrderId: foodOrderId ?? this.foodOrderId,
    );
  }
}
