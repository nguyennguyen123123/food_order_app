import 'package:food_delivery_app/models/account.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_in_out.g.dart';

@JsonSerializable()
class CheckInOut {
  final int? id;
  @JsonKey(includeToJson: true, includeFromJson: false, name: 'user_id')
  final String? userId;
  @JsonKey(name: 'check_in_time')
  final String? checkInTime;
  @JsonKey(name: 'check_out_time')
  final String? checkOutTime;
  @JsonKey(name: 'total_orders')
  final int? totalOrders;
  @JsonKey(includeToJson: false, includeFromJson: true, name: 'user_id')
  Account? users;
  @JsonKey(name: 'total_price')
  double totalPrice;

  CheckInOut({
    this.id,
    this.userId,
    this.checkInTime,
    this.checkOutTime,
    this.totalOrders,
    this.users,
    this.totalPrice = 0,
  });

  Map<String, dynamic> toJson() => _$CheckInOutToJson(this);

  factory CheckInOut.fromJson(Map<String, dynamic> json) => _$CheckInOutFromJson(json);
}
