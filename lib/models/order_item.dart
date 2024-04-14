// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:food_delivery_app/models/food_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  @JsonKey(name: 'order_item_id')
  String? orderItemId;
  @JsonKey(name: 'food_id', includeFromJson: true, includeToJson: false)
  FoodModel? food;
  @JsonKey(name: 'food_id', includeFromJson: false, includeToJson: true)
  String? foodId;
  @JsonKey(defaultValue: 1)
  int quantity;
  String? note;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int orignalQuantity;
  @JsonKey(name: 'sort_order')
  int? sortOder;

  OrderItem({
    this.orderItemId,
    this.food,
    this.foodId,
    this.quantity = 1,
    this.note,
    this.orignalQuantity = 1,
    this.sortOder,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  OrderItem copyWith({
    String? orderItemId,
    FoodModel? food,
    String? foodId,
    int? quantity,
    String? note,
    int? orignalQuantity,
    int? sortOder,
  }) {
    return OrderItem(
      orderItemId: orderItemId ?? this.orderItemId,
      food: food ?? this.food,
      foodId: foodId ?? this.foodId,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      orignalQuantity: orignalQuantity ?? this.orignalQuantity,
      sortOder: sortOder ?? this.sortOder,
    );
  }
}
