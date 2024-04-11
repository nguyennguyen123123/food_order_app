// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_order.g.dart';

@JsonSerializable()
class FoodOrder {
  @JsonKey(name: 'order_id')
  String? orderId;
  @JsonKey(name: 'food_order_item', includeFromJson: false, includeToJson: false)
  List<OrderItem>? orderItems;
  @JsonKey(name: 'voucher_price')
  double? voucherPrice;
  @JsonKey(name: 'table_number')
  String? tableNumber;
  double? total;
  @JsonKey(includeFromJson: true, includeToJson: false, name: 'user_order_id')
  Account? userOrder;
  @JsonKey(includeFromJson: false, includeToJson: true, name: 'user_order_id')
  String? userOrderId;
  @JsonKey(name: 'order_status')
  String? orderStatus;
  @JsonKey(name: 'created_at', includeToJson: false)
  String? createdAt;
  FoodOrder({
    this.orderId,
    this.orderItems,
    this.voucherPrice,
    this.tableNumber,
    this.total,
    this.userOrder,
    this.userOrderId,
    this.orderStatus,
    this.createdAt,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) => _$FoodOrderFromJson(json);

  Map<String, dynamic> toJson() => _$FoodOrderToJson(this);
}
