// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'food_order_item.g.dart';

@JsonSerializable()
class FoodOrderItem {
  int? id;
  @JsonKey(name: 'food_order_id')
  String? foodOrderId;
  @JsonKey(name: 'order_item_id')
  String? orderItemId;
  FoodOrderItem({
    this.id,
    this.foodOrderId,
    this.orderItemId,
  });

  factory FoodOrderItem.fromJson(Map<String, dynamic> json) => _$FoodOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$FoodOrderItemToJson(this);
}
