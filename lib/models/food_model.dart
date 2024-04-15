// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
 * Copyright (c) 2021 Akshay Jadhav <jadhavakshay0701@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:food_delivery_app/models/food_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_model.g.dart';

@JsonSerializable()
class FoodModel {
  final String? foodId;
  final String? name;
  final String? description;
  final double? price;
  final String? image;
  @JsonKey(includeToJson: true, includeFromJson: false)
  final String? typeId;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(includeToJson: false, includeFromJson: true, name: 'typeId')
  FoodType? foodType;
  @JsonKey(name: 'number_order', includeToJson: false)
  int? numberOrder;

  FoodModel({
    this.foodId,
    this.name,
    this.description,
    this.price,
    this.image,
    this.typeId,
    this.createdAt,
    this.foodType,
    this.numberOrder,
  });

  Map<String, dynamic> toJson() => _$FoodModelToJson(this);

  Map toMap(FoodModel food) => _$FoodModelToJson(this);

  factory FoodModel.fromJson(Map<String, dynamic> json) => _$FoodModelFromJson(json);

  FoodModel copyWith({
    String? foodId,
    String? name,
    String? description,
    double? price,
    String? image,
    String? typeId,
    String? createdAt,
    FoodType? foodType,
    int? numberOrder,
  }) {
    return FoodModel(
      foodId: foodId ?? this.foodId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      typeId: typeId ?? this.typeId,
      createdAt: createdAt ?? this.createdAt,
      foodType: foodType ?? this.foodType,
      numberOrder: numberOrder ?? this.numberOrder,
    );
  }
}
