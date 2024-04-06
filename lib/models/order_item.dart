// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:food_delivery_app/models/food_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  FoodModel? food;
  @JsonKey(name: 'food_id')
  String? foodId;
  int? quantity;
  String? note;

  OrderItem({
    this.food,
    this.foodId,
    this.quantity,
    this.note,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  OrderItem copyWith({
    FoodModel? food,
    String? foodId,
    int? quantity,
    String? note,
  }) {
    return OrderItem(
      food: food ?? this.food,
      foodId: foodId ?? this.foodId,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
