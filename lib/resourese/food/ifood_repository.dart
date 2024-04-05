import 'dart:io';

import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class IFoodRepository extends IBaseRepository {
  Future<String> updateImages(String path, File file, {String? fileName});
  Future<FoodModel?> addFood(FoodModel foodModel);
  Future<List<FoodModel>?> getFood();
  Future<FoodType?> addTypeFood(FoodType foodModel);
  Future<List<FoodType>?> getTypeFood();
}
