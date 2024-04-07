import 'package:json_annotation/json_annotation.dart';

part 'food_type.g.dart';

@JsonSerializable()
class FoodType {
  final String? typeId;
  final String? name;
  final String? description;
  final String? image;
  final String? createdAt;

  FoodType({
    this.typeId,
    this.name,
    this.description,
    this.image,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'name': name,
      'description': description,
      'image': image,
      'created_at': createdAt,
    };
  }

  Map toMap(FoodType food) {
    var data = Map<String, dynamic>();
    data['typeId'] = food.typeId;
    data['name'] = food.name;
    data['description'] = food.description;
    data['image'] = food.image;
    data['created_at'] = food.createdAt;
    return data;
  }

  factory FoodType.fromJson(Map<String, dynamic> json) => _$FoodTypeFromJson(json);
}
