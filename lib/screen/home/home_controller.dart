import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final IFoodRepository foodRepository;
  final IPrinterRepository printerRepository;

  HomeController({required this.foodRepository, required this.printerRepository});

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
}
