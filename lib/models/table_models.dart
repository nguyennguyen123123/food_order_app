import 'package:json_annotation/json_annotation.dart';

part 'table_models.g.dart';

@JsonSerializable()
class TableModels {
  @JsonKey(name: 'table_id')
  String? tableId;
  @JsonKey(name: 'table_number') // số bàn
  int? tableNumber;
  @JsonKey(name: 'number_of_order') // số đơn
  int? numberOfOrder;
  @JsonKey(name: 'number_of_people') // số khách
  int? numberOfPeople;
  @JsonKey(name: 'created_at')
  String? createdAt;

  TableModels({
    this.tableId,
    this.tableNumber,
    this.numberOfOrder,
    this.numberOfPeople,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => _$TableModelsToJson(this);

  Map toMap(TableModels tableModels) => _$TableModelsToJson(this);

  factory TableModels.fromJson(Map<String, dynamic> json) => _$TableModelsFromJson(json);
}
