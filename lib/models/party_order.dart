// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:json_annotation/json_annotation.dart';

part 'party_order.g.dart';

@JsonSerializable()
class PartyOrder {
  @JsonKey(name: 'party_order_id')
  String? partyOrderId;
  @JsonKey(name: 'food_order_item', includeFromJson: false, includeToJson: false)
  List<OrderItem>? orderItems;
  @JsonKey(name: 'voucher_price')
  double? voucherPrice;
  @JsonKey(name: 'voucher_type')
  String? voucherType;
  @JsonKey(name: 'total_price')
  double? total;
  @JsonKey(name: 'order_status')
  String? orderStatus;
  @JsonKey(name: 'order_id')
  String? orderId;
  @JsonKey(name: 'created_at', includeToJson: false)
  String? createdAt;
  @JsonKey(name: 'party_number')
  int? partyNumber;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Voucher? voucher;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int numberOfGangs;
  PartyOrder({
    this.partyOrderId,
    this.orderItems,
    this.voucherPrice,
    this.total,
    this.orderStatus,
    this.orderId,
    this.createdAt,
    this.partyNumber,
    this.voucher,
    this.numberOfGangs = 0,
    this.voucherType,
  });

  factory PartyOrder.fromJson(Map<String, dynamic> json) => _$PartyOrderFromJson(json);

  Map<String, dynamic> toJson() => _$PartyOrderToJson(this);

  PartyOrder copyWith({
    String? partyOrderId,
    List<OrderItem>? orderItems,
    double? voucherPrice,
    String? voucherType,
    double? total,
    String? orderStatus,
    String? orderId,
    String? createdAt,
    int? partyNumber,
    Voucher? voucher,
    int? numberOfGangs,
  }) {
    return PartyOrder(
      partyOrderId: partyOrderId ?? this.partyOrderId,
      orderItems: orderItems ?? this.orderItems,
      voucherPrice: voucherPrice ?? this.voucherPrice,
      voucherType: voucherType ?? this.voucherType,
      total: total ?? this.total,
      orderStatus: orderStatus ?? this.orderStatus,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      partyNumber: partyNumber ?? this.partyNumber,
      voucher: voucher ?? this.voucher,
      numberOfGangs: numberOfGangs ?? this.numberOfGangs,
    );
  }
}

extension PartyOrderExtension on PartyOrder {
  double get totalPriceWithoutVoucher {
    var total = 0.0;
    for (final item in (orderItems ?? <OrderItem>[])) {
      total += item.quantity * (item.food?.price ?? 0);
    }
    return total;
  }

  double get totalPrice {
    var total = 0.0;
    for (final item in (orderItems ?? <OrderItem>[])) {
      total += item.quantity * (item.food?.price ?? 0);
    }
    if (voucher != null) {
      if (voucher?.discountType == DiscountType.amount) {
        total -= voucher?.discountValue ?? 0;
      } else {
        total -= total * ((voucher?.discountValue ?? 100) / 100);
      }
      return total;
    }
    if (voucherPrice != null && voucherType != null) {
      if (voucherType == DiscountType.amount.toString()) {
        total -= (voucherPrice ?? 0);
      } else {
        total -= total * ((voucherPrice ?? 100) / 100);
      }
    }
    return total;
  }

  double get totalPriceWithoutPartyDone {
    var total = 0.0;
    for (final item in (orderItems ?? <OrderItem>[])) {
      if (item.partyOrderStaus == ORDER_STATUS.CREATED) {
        total += item.quantity * (item.food?.price ?? 0);
      }
    }
    if (voucher != null) {
      if (voucher?.discountType == DiscountType.amount) {
        total -= voucher?.discountValue ?? 0;
      } else {
        total -= total * ((voucher?.discountValue ?? 100) / 100);
      }
      return total;
    }
    if (voucherPrice != null) {
      total -= (voucherPrice ?? 0);
    }
    return total;
  }

  void clearVoucher() {
    this.voucherPrice = null;
    this.voucher = null;
    this.voucherType = null;
  }
}
