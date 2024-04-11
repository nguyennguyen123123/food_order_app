import 'package:json_annotation/json_annotation.dart';

part 'table.g.dart';

@JsonSerializable()
class Table {
  @JsonKey(name: 'table_id')
  String? tableId;
  @JsonKey(name: 'table_number') // số bàn
  int? tableNumber;
  @JsonKey(name: 'number_of_order ') // số đơn
  int? numberOfOrder;
  @JsonKey(name: 'number_of_people ') // số người
  int? numberOfPeople;
  @JsonKey(name: 'created_at')
  String? createdAt;

  Table({
    this.tableId,
    this.tableNumber,
    this.numberOfOrder,
    this.numberOfPeople,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => _$TableToJson(this);

  Map toMap(Table table) => _$TableToJson(this);

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);
}
