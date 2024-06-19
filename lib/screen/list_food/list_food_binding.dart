import 'package:food_delivery_app/screen/list_food/list_food_controller.dart';
import 'package:get/get.dart';

class ListFoodBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ListFoodController(
      parameter: Get.arguments,
      foodRepository: Get.find(),
    ));
  }
}
