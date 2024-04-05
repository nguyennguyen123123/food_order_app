import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';

class FoodRepository extends IFoodRepository {
  final BaseService baseService;

  FoodRepository({required this.baseService});

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
  Future<List<FoodModel>?> getFood() async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.FOOD)
          .select()
          .withConverter((data) => data.map((e) => FoodModel.fromMap(e)).toList());

      return response.toList();
    } catch (e) {
      handleError(e);
      rethrow;
    }
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
          .withConverter((data) => data.map((e) => FoodType.fromMap(e)).toList());

      return response.toList();
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
