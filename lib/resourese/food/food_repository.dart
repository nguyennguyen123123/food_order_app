import 'dart:io';

import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodRepository extends IFoodRepository {
  final BaseService baseService;

  FoodRepository({required this.baseService});

  @override
  Future<String> updateImages(String path, File file, {String? fileName}) async {
    try {
      final name = fileName ?? basename(path);

      await baseService.client.storage.from(BUCKET_ID.IMAGE).upload(
            name,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      return baseService.client.storage.from(BUCKET_ID.IMAGE).getPublicUrl(name);
    } catch (error) {
      print(error);
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<FoodModel?> addFood(FoodModel foodModel) async {
    try {
      final response = await baseService.client.from(TABLE_NAME.FOOD).insert(foodModel.toJson());

      return response;
    } catch (e) {
      print(e);
      handleError(e);

      return null;
    }
  }

  @override
  Future<List<FoodModel>> getFood({int page = 0, int limit = LIMIT}) async {
    try {
      final food = baseService.client.from(TABLE_NAME.FOOD).select("*, typeId (*)");

      final response = await food
          .limit(limit)
          .range(page * limit, (page + 1) * limit)
          .withConverter((data) => data.map((e) => FoodModel.fromJson(e)).toList());

      return response.toList();
    } catch (e) {
      handleError(e);
    }
    return [];
  }

  @override
  Future<FoodType?> addTypeFood(FoodType foodType) async {
    try {
      final response = await baseService.client.from(TABLE_NAME.FOODTYPE).insert(foodType.toJson());

      return response;
    } catch (e) {
      print(e);
      handleError(e);

      return null;
    }
  }

  @override
  Future<List<FoodType>?> getTypeFood() async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.FOODTYPE)
          .select()
          .withConverter((data) => data.map((e) => FoodType.fromJson(e)).toList());

      return response.toList();
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  @override
  Future<FoodModel?> editFood(String foodId, FoodModel foodModel) async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.FOOD)
          .update(foodModel.toJson())
          .eq('foodId', foodId)
          .select()
          .withConverter((data) => data.map((e) => FoodModel.fromJson(e)).toList());

      // if (response.error != null) {
      //   throw response.error!;
      // }

      return response.first;
    } catch (error) {
      print(error);
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> deleteFood(String foodId) async {
    try {
      final response = await baseService.client.from(TABLE_NAME.FOOD).delete().match({'foodId': foodId}).select();

      return response.first;
    } catch (error) {
      print(error);
      handleError(error);
      return null;
    }
  }

  @override
  Future<List<FoodModel>> getListFoodByKeyword(
      {String keyword = '', String? typeId, int page = 0, int limit = LIMIT}) async {
    try {
      var query = baseService.client.from(TABLE_NAME.FOOD).select("*, typeId (*)");
      if (keyword.isNotEmpty) {
        // query = query.textSearch("name", "'$keyword'");
        query = query.like("name", "%$keyword%");
      }
      if (typeId != null) {
        query = query.eq("typeId", typeId);
      }
      final response = await query
          .limit(limit)
          .range(page * limit, (page + 1) * limit)
          .withConverter((data) => data.map((e) => FoodModel.fromJson(e)).toList());
      return response.toList();
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  @override
  Future<List<FoodModel>> getListDataFoodType() async {
    try {
      final response = await baseService.client.from(TABLE_NAME.FOOD).select("*, typeId (*)");

      final List<Map<String, dynamic>> data = response;

      final List<FoodModel> foodList = data.map((json) => FoodModel.fromJson(json)).toList();

      return foodList;
    } catch (error) {
      handleError(error);

      return [];
    }
  }

  @override
  Future<void> increaseNumberOrderOfFood(String foodId, int number) async {
    try {
      await baseService.client.from(TABLE_NAME.FOOD).update({'number_order': number}).eq('food_id', foodId);
    } catch (error) {
      print(error);
      handleError(error);
      return null;
    }
  }
}
