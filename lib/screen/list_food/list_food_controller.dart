import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/screen/list_food/list_food_parameter.dart';
import 'package:get/get.dart';

class ListFoodController extends GetxController {
  final ListFoodParameter? parameter;
  final IFoodRepository foodRepository;

  String? get foodTypeId => parameter?.foodType?.typeId;

  ListFoodController({required this.foodRepository, this.parameter});

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  int page = 0;
  int limit = LIMIT;
  final foods = Rx<List<FoodModel>?>(null);
  final isSeaching = Rx(false);
  var keyword = '';

  void updateSearchStatus(bool newVal) => isSeaching.value = newVal;

  void updateKeyword(String text) {
    keyword = text;
    onRefresh();
  }

  Future<void> onRefresh() async {
    foods.value = null;
    final result = await foodRepository.getListFoodByKeyword(
      limit: limit,
      keyword: keyword,
      page: page,
      typeId: foodTypeId,
    );
    foods.value = result;
  }

  Future<bool> onLoadMore() async {
    final length = (foods.value ?? []).length;
    if (length < LIMIT * (page + 1)) return false;
    page += 1;
    final result = await foodRepository.getListFoodByKeyword(
      limit: limit,
      keyword: keyword,
      page: page,
      typeId: foodTypeId,
    );
    foods.update((val) => val?.addAll(result));
    if (result.length < limit) return false;
    return true;
  }
}
