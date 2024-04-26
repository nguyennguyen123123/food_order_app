import 'package:food_delivery_app/screen/food/type_food/upsert_type_food_controller.dart';
import 'package:get/get.dart';

class UpsertTypeFoodBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UpsertTypeFoodController(
      foodRepository: Get.find(),
      accountService: Get.find(),
      printerService: Get.find(),
    ));
  }
}
