import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final IFoodRepository foodRepository;
  final IPrinterRepository printerRepository;
  final OrderCartService cartService;

  HomeController({required this.foodRepository, required this.printerRepository, required this.cartService});

  final foodTypes = Rx<List<FoodType>?>(null);
  final foods = Rx<List<FoodModel>?>(null);
  final printer = Rx<List<Printer>?>(null);

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

  Future<void> getPrinter() async {
    final result = await printerRepository.getPrinter();

    printer.value = result as List<Printer>;
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
