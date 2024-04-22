import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:food_delivery_app/screen/type_details/type_details_controller.dart';
import 'package:get/get.dart';

class TypeDetailsBinding implements Binding {
  @override
  void dependencies() {
    Get.put(TypeDetailsController(
      foodRepository: Get.find(),
      cartService: Get.find(),
      paramter: Get.arguments,
    ));
  }
}
