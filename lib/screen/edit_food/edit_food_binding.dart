import 'package:food_delivery_app/screen/edit_food/edit_food_controller.dart';
import 'package:get/get.dart';

class EditFoodBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EditFoodController(
      parameter: Get.arguments,
      foodRepository: Get.find(),
      accountService: Get.find(),
    ));
  }
}
