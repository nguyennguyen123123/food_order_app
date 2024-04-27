// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  @JsonKey(name: 'created_at')
  String? createdAt;
  String? email;
  String? role;
  String? name;
  String? gender;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'check_in_time')
  String? checkInTime;
  @JsonKey(name: 'number_of_order')
  int? numberOfOrder;
  @JsonKey(name: 'total_order_price')
  double totalOrderPrice;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String password;

  Account({
    this.createdAt,
    this.email,
    this.role,
    this.name,
    this.gender,
    this.userId,
    this.checkInTime,
    this.numberOfOrder,
    this.totalOrderPrice = 0,
    this.password = '',
  });

  Map<String, dynamic> toMap() => _$AccountToJson(this);

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Account copyWith({
    String? createdAt,
    String? email,
    String? role,
    String? name,
    String? gender,
    String? userId,
    String? checkInTime,
    int? numberOfOrder,
    double? totalOrderPrice,
    String? password,
  }) {
    return Account(
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      userId: userId ?? this.userId,
      checkInTime: checkInTime ?? this.checkInTime,
      numberOfOrder: numberOfOrder ?? this.numberOfOrder,
      totalOrderPrice: totalOrderPrice ?? this.totalOrderPrice,
      password: password ?? this.password,
    );
  }
}
