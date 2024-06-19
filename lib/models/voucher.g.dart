// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      voucherId: json['voucher_id'] as String?,
      code: json['code'] as String?,
      discountValue: (json['discount_value'] as num? ?? 0).toDouble(),
      discountType: $enumDecodeNullable(_$DiscountTypeEnumMap, json['discount_type']),
      name: json['name'] as String?,
      expiryDate: json['expiry_date'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'voucher_id': instance.voucherId,
      'code': instance.code,
      'name': instance.name,
      'discount_value': instance.discountValue,
      'discount_type': _$DiscountTypeEnumMap[instance.discountType],
      'expiry_date': instance.expiryDate,
      'created_at': instance.createdAt,
    };

const _$DiscountTypeEnumMap = {
  DiscountType.percentage: 'percentage',
  DiscountType.amount: 'amount',
};
