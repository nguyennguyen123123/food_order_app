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

class FoodModel {
  final String foodId;
  final String? name;
  final String? description;
  final String? price;
  final String? image;
  final String? typeId;
  final String? createdAt;

  FoodModel({
    required this.foodId,
    this.name,
    this.description,
    this.price,
    this.image,
    this.typeId,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'typeId': typeId,
      'created_at': createdAt,
    };
  }

  Map toMap(FoodModel food) {
    var data = Map<String, dynamic>();
    data['foodId'] = food.foodId;
    data['name'] = food.name;
    data['description'] = food.description;
    data['price'] = food.price;
    data['image'] = food.image;
    data['typeId'] = food.typeId;
    data['created_at'] = food.createdAt;
    return data;
  }

  factory FoodModel.fromMap(
    Map<dynamic, dynamic> mapData,
  ) {
    return FoodModel(
      foodId: mapData['foodId'],
      name: mapData['name'],
      description: mapData['description'],
      price: mapData['price'],
      image: mapData['image'],
      typeId: mapData['typeId'],
      createdAt: mapData['created_at'],
    );
  }
}
