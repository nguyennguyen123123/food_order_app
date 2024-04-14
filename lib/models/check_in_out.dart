import 'package:json_annotation/json_annotation.dart';

part 'check_in_out.g.dart';

@JsonSerializable()
class CheckInOut {
  final int? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'check_in_time')
  final String? checkInTime;
  @JsonKey(name: 'check_out_time')
  final String? checkOutTime;
  @JsonKey(name: 'total_orders')
  final int? totalOrders;

  CheckInOut({
    this.id,
    this.userId,
    this.checkInTime,
    this.checkOutTime,
    this.totalOrders,
  });

  Map<String, dynamic> toJson() => _$CheckInOutToJson(this);

  Map toMap(CheckInOut checkInOut) => _$CheckInOutToJson(this);

  factory CheckInOut.fromJson(Map<String, dynamic> json) => _$CheckInOutFromJson(json);
}
