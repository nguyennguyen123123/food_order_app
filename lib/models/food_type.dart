import 'package:json_annotation/json_annotation.dart';

part 'food_type.g.dart';

@JsonSerializable()
class FoodType {
  String? typeId;
  String? name;
  String? description;
  String? image;
  @JsonKey(name: 'parent_type_id')
  String? parentTypeId;
  int? order;
  @JsonKey(name: 'created_at')
  String? createdAt;

  FoodType({
    this.typeId,
    this.name,
    this.description,
    this.image,
    this.parentTypeId,
    this.order,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => _$FoodTypeToJson(this);

  Map toMap(FoodType foodType) => _$FoodTypeToJson(this);

  factory FoodType.fromJson(Map<String, dynamic> json) => _$FoodTypeFromJson(json);
}
