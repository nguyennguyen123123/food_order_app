import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

enum DiscountType {
  percentage,
  amount,
}

@JsonSerializable()
class Voucher {
  @JsonKey(name: 'voucher_id')
  String? voucherId;
  String? code;
  String? name;
  @JsonKey(name: 'discount_value')
  int? discountValue;
  @JsonKey(name: 'discount_type')
  DiscountType? discountType;
  @JsonKey(name: 'expiry_date')
  String? expiryDate;
  @JsonKey(name: 'created_at')
  String? createdAt;

  Voucher({
    this.voucherId,
    this.code,
    this.discountValue, // Giá trị giảm giá
    this.discountType, // Loại giảm giá
    this.name,
    this.expiryDate,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => _$VoucherToJson(this);

  Map toMap(Voucher voucher) => _$VoucherToJson(this);

  factory Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);
}
