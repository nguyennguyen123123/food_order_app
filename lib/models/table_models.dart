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
  @JsonKey(name: 'number_of_order') // số đơn
  int? numberOfOrder;
  @JsonKey(name: 'number_of_people') // số khách
  int? numberOfPeople;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'order', includeToJson: false)
  FoodOrder? foodOrder;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? foodOrderId;

  TableModels({
    this.tableId,
    this.tableNumber,
    this.numberOfOrder,
    this.numberOfPeople,
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
    int? numberOfOrder,
    int? numberOfPeople,
    String? createdAt,
    FoodOrder? foodOrder,
    String? foodOrderId,
  }) {
    return TableModels(
      tableId: tableId ?? this.tableId,
      tableNumber: tableNumber ?? this.tableNumber,
      numberOfOrder: numberOfOrder ?? this.numberOfOrder,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      createdAt: createdAt ?? this.createdAt,
      foodOrder: foodOrder ?? this.foodOrder,
      foodOrderId: foodOrderId ?? this.foodOrderId,
    );
  }
}
