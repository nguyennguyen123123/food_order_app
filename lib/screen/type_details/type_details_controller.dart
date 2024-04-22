import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/screen/type_details/type_details_parameter.dart';
import 'package:get/get.dart';

class TypeDetailsController extends GetxController {
  final IFoodRepository foodRepository;
  final OrderCartService cartService;
  final TypeDetailsParamter paramter;
  final orderCartNotifier = ValueNotifier(0);

  TypeDetailsController({
    required this.foodRepository,
    required this.cartService,
    required this.paramter,
  });

  final foodTypes = Rx<List<FoodType>?>(null);
  final foods = Rx<List<FoodModel>?>(null);

  var selectedFoodTypes = <FoodType>[].obs;

  void addFoodType(FoodType foodType) {
    selectedFoodTypes.add(foodType);
  }

  void removeFoodType(FoodType foodType) {
    selectedFoodTypes.remove(foodType);
  }

  int page = 0;
  int limit = LIMIT;

  int typePage = 0;

  @override
  void onClose() {
    orderCartNotifier.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    onRefresh();
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

  Future<bool> onLoadMoreType() async {
    final length = (foodTypes.value ?? []).length;
    if (length < LIMIT * (page + 1)) return false;
    typePage += 1;
    final lastId = selectedFoodTypes.isNotEmpty ? selectedFoodTypes.last.typeId : null;
    final result = await foodRepository.filterTypeFood(parentTypeFoodId: lastId, page: typePage, limit: limit);

    foodTypes.update((val) => val?.addAll(result));
    if (result.length < limit) return false;
    return true;
  }

  void addItemToCart(FoodModel food) {
    cartService.onAddItemToCart(food, paramter.gangIndex);
    orderCartNotifier.value += 1;
  }

  void updateQuantityCartItem(int quantity, FoodModel food) {
    cartService.onUpdateQuantityItemInCart(quantity, food, paramter.gangIndex);
    orderCartNotifier.value += 1;
  }

  void updateFoodTypeToList(FoodType foodType) async {
    final foodTypeIndex = selectedFoodTypes.indexWhere((element) => element.typeId == foodType.typeId);
    if (foodTypeIndex != -1) {
      // removeFoodType(foodType);

      // if (selectedFoodTypes.first.parentTypeId != null) {
      //   onRefresh(selectedFoodTypes.first.parentTypeId ?? '');
      // } else {
      //   onRefresh(selectedFoodTypes.first.typeId ?? '');
      // }
      return;
    } else {
      addFoodType(foodType);
      onRefresh(typeId: foodType.typeId);
    }
  }

  Future<void> onRefresh({String? typeId}) async {
    typePage = 0;
    page = 0;
    foods.value = null;
    foodTypes.value = null;
    final result = await Future.wait([
      foodRepository.filterTypeFood(parentTypeFoodId: typeId),
      foodRepository.getListFoodByKeyword(
        limit: limit,
        keyword: '',
        page: page,
        typeId: typeId,
      )
    ]);
    foodTypes.value = result[0] as List<FoodType>;
    foods.value = result[1] as List<FoodModel>;
  }
}
