// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:food_delivery_app/constant/app_constant_key.dart';
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
  int sortOder;
  @JsonKey(name: 'party_order_id', includeFromJson: false, includeToJson: true)
  String? partyOderId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int partyIndex;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String partyOrderStaus;

  OrderItem({
    this.orderItemId,
    this.food,
    this.foodId,
    this.quantity = 1,
    this.note,
    this.orignalQuantity = 1,
    this.sortOder = 0,
    this.partyOderId,
    this.partyIndex = 0,
    this.partyOrderStaus = ORDER_STATUS.CREATED,
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
    String? partyOderId,
    int? partyIndex,
    String? partyOrderStaus,
  }) {
    return OrderItem(
      orderItemId: orderItemId ?? this.orderItemId,
      food: food ?? this.food,
      foodId: foodId ?? this.foodId,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      orignalQuantity: orignalQuantity ?? this.orignalQuantity,
      sortOder: sortOder ?? this.sortOder,
      partyOderId: partyOderId ?? this.partyOderId,
      partyIndex: partyIndex ?? this.partyIndex,
      partyOrderStaus: partyOrderStaus ?? this.partyOrderStaus,
    );
  }
}
