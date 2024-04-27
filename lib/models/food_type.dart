// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  @JsonKey(name: 'printers', defaultValue: [], includeToJson: false)
  List<String> printersIs;

  FoodType({
    this.typeId,
    this.name,
    this.description,
    this.image,
    this.parentTypeId,
    this.order,
    this.createdAt,
    this.printersIs = const [],
  });

  Map<String, dynamic> toJson() => _$FoodTypeToJson(this);

  factory FoodType.fromJson(Map<String, dynamic> json) => _$FoodTypeFromJson(json);

  FoodType copyWith({
    String? typeId,
    String? name,
    String? description,
    String? image,
    String? parentTypeId,
    int? order,
    String? createdAt,
    List<String>? printersIs,
  }) {
    return FoodType(
      typeId: typeId ?? this.typeId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      parentTypeId: parentTypeId ?? this.parentTypeId,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      printersIs: printersIs ?? this.printersIs,
    );
  }
}
