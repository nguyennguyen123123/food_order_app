import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/screen/product/product_details_parameter.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  ProductDetailsParameter parameter;
  final IFoodRepository foodRepository;

  FoodModel? get foodParametar => parameter.foodModel;

  ProductDetailsController({required this.parameter, required this.foodRepository});

  final foods = Rx<List<FoodModel>?>(null);

  int page = 0;
  int limit = LIMIT;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  Future<void> onRefresh() async {
    foods.value = null;
    final result = await foodRepository.getListFoodByKeyword(
      limit: limit,
      keyword: '',
      page: page,
      typeId: foodParametar?.foodType?.typeId ?? '',
    );
    foods.value = result;
  }
}
