// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

// part 'summarize_order.g.dart';

@JsonSerializable()
class SummarizeOrder {
  int? id;
  int? day;
  int? month;
  int? year;
  int? totalOrder;
  double? totalOrderPrice;

  SummarizeOrder({
    this.id,
    this.day,
    this.month,
    this.year,
    this.totalOrder,
    this.totalOrderPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'day': day,
      'month': month,
      'year': year,
      'totalOrder': totalOrder,
      'totalOrderPrice': totalOrderPrice,
    };
  }

  factory SummarizeOrder.fromMap(Map<String, dynamic> map) {
    return SummarizeOrder(
      id: map['id'] != null ? map['id'] as int : null,
      day: map['day'] != null ? map['day'] as int : null,
      month: map['month'] != null ? map['month'] as int : null,
      year: map['year'] != null ? map['year'] as int : null,
      totalOrder: map['totalOrder'] != null ? map['totalOrder'] as int : null,
      totalOrderPrice: map['totalOrderPrice'] != null ? map['totalOrderPrice'] as double : null,
    );
  }
}
