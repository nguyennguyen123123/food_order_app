// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_order.g.dart';

@JsonSerializable()
class FoodOrder {
  @JsonKey(name: 'order_id')
  String? orderId;
  @JsonKey(name: 'order_items', includeFromJson: true, includeToJson: false)
  List<OrderItem>? orderItems;
  @JsonKey(name: 'order_items', includeFromJson: false, includeToJson: true)
  List<String>? orderItemsId;
  @JsonKey(name: 'voucher_price')
  double? voucherPrice;
  @JsonKey(name: 'table_number')
  String? tableNumber;
  double? total;
  @JsonKey(includeFromJson: true, includeToJson: false, name: 'user_order_id')
  Account? userOrder;
  @JsonKey(includeFromJson: false, includeToJson: true, name: 'user_order_id')
  String? userOrderId;
  FoodOrder({
    this.orderId,
    this.orderItems,
    this.orderItemsId,
    this.voucherPrice,
    this.tableNumber,
    this.total,
    this.userOrder,
    this.userOrderId,
  });
}
