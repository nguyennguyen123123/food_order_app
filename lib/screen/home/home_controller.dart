import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final IFoodRepository foodRepository;
  final OrderCartService cartService;

  HomeController({required this.foodRepository, required this.cartService});

  final foodTypes = Rx<List<FoodType>?>(null);
  final foods = Rx<List<FoodModel>?>(null);

  @override
  void onInit() async {
    super.onInit();
    onGetFood();
  }

  Future<void> onGetFood() async {
    final result = await Future.wait([
      foodRepository.getTypeFood(),
      foodRepository.getFood(),
    ]);
    foodTypes.value = result[0] as List<FoodType>;
    foods.value = result[1] as List<FoodModel>;
  }

  Map<String, List<FoodModel>> groupFoodByType() {
    if (foods.value?.isEmpty == true) return {};
    Map<String, List<FoodModel>> groupedFood = {};

    for (var food in foods.value!) {
      final typeId = food.foodType?.typeId;
      if (!groupedFood.containsKey(typeId)) {
        groupedFood[typeId ?? ''] = [];
      }
      groupedFood[typeId]!.add(food);
    }

    return groupedFood;
  }
}
