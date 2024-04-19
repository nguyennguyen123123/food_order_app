import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:get/get.dart';

class TypeDetailsController extends GetxController {
  final IFoodRepository foodRepository;

  TypeDetailsController({required this.foodRepository});

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

  Future<void> onRefresh(String typeId) async {
    foods.value = null;
    final result = await foodRepository.getListFoodByKeyword(
      limit: limit,
      keyword: '',
      page: page,
      typeId: typeId,
    );
    foods.value = result;
  }
}
