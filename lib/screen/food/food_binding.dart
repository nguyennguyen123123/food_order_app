import 'package:food_delivery_app/screen/food/food_controller.dart';
import 'package:get/get.dart';

class FoodBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FoodController(
      foodRepository: Get.find(),
      accountService: Get.find(),
    ));
  }
}
