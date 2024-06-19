import 'package:food_delivery_app/screen/food/edit_type/edit_type_controller.dart';
import 'package:get/get.dart';

class EditTypeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EditTypeController(
      parameter: Get.arguments,
      accountService: Get.find(),
      foodRepository: Get.find(),
      printerService: Get.find(),
    ));
  }
}
