import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:get/get.dart';

class TypeDetailsController extends GetxController {
  final IFoodRepository foodRepository;
  final OrderCartService cartService;
  final orderCartNotifier = ValueNotifier(0);

  TypeDetailsController({required this.foodRepository, required this.cartService});

  final foodTypes = Rx<List<FoodType>?>(null);
  final foods = Rx<List<FoodModel>?>(null);

  int page = 0;
  int limit = LIMIT;

  @override
  void onClose() {
    orderCartNotifier.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    onGetFood();
  }

  Future<void> onGetFood() async {
    final result = await Future.wait([
      foodRepository.getTypeFood(),
      foodRepository.getFood(page: page, limit: limit),
    ]);
    foodTypes.value = result[0] as List<FoodType>;
    foods.value = result[1] as List<FoodModel>;
  }

  Future<bool> onLoadMoreFoods() async {
    final length = (foods.value ?? []).length;
    if (length < LIMIT * (page + 1)) return false;
    page += 1;

    final result = await foodRepository.getFood(page: page, limit: limit);

    foods.update((val) => val?.addAll(result));
    if (result.length < limit) return false;
    return true;
  }

  void addItemToCart(FoodModel food) {
    cartService.onAddItemToCart(food);
    orderCartNotifier.value += 1;
  }

  void updateQuantityCartItem(int quantity, FoodModel food) {
    cartService.onUpdateQuantityItemInCart(quantity, food);
    orderCartNotifier.value += 1;
  }
}
