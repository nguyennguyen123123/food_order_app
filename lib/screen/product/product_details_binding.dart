import 'package:food_delivery_app/screen/product/product_details_controller.dart';
import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:get/get.dart';

class ProductDetailsBinding implements Binding {
  @override
  void dependencies() {
    Get.put(ProductDetailsController(
      parameter: Get.arguments,
      foodRepository: Get.find(),
    ));
  }
}
