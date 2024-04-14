// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_order.g.dart';

@JsonSerializable()
class FoodOrder {
  @JsonKey(name: 'order_id')
  String? orderId;
  @JsonKey(name: 'food_order_item', includeFromJson: true, includeToJson: false)
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
  @JsonKey(name: 'party_orders', includeFromJson: false, includeToJson: false)
  List<PartyOrder>? partyOrders;
  @JsonKey(name: 'order_type')
  String? orderType;
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
    this.partyOrders,
    this.orderType,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) => _$FoodOrderFromJson(json);

  Map<String, dynamic> toJson() => _$FoodOrderToJson(this);

  FoodOrder copyWith({
    String? orderId,
    List<OrderItem>? orderItems,
    double? voucherPrice,
    String? tableNumber,
    double? total,
    Account? userOrder,
    String? userOrderId,
    String? orderStatus,
    String? createdAt,
    List<PartyOrder>? partyOrders,
    String? orderType,
  }) {
    return FoodOrder(
      orderId: orderId ?? this.orderId,
      orderItems: orderItems ?? this.orderItems,
      voucherPrice: voucherPrice ?? this.voucherPrice,
      tableNumber: tableNumber ?? this.tableNumber,
      total: total ?? this.total,
      userOrder: userOrder ?? this.userOrder,
      userOrderId: userOrderId ?? this.userOrderId,
      orderStatus: orderStatus ?? this.orderStatus,
      createdAt: createdAt ?? this.createdAt,
      partyOrders: partyOrders ?? this.partyOrders,
      orderType: orderType ?? this.orderType,
    );
  }
}

extension FoodOrderExtension on FoodOrder {
  int get totalPrice {
    if (partyOrders?.isEmpty ?? true) {
      return 0;
    }
    var total = 0.0;
    for (final order in partyOrders!) {
      total += order.priceInVoucher;
    }
    return total.toInt();
  }
}
