import 'package:food_delivery_app/screen/order_detail/order_detail_controller.dart';
import 'package:get/get.dart';

class OrderDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(OrderDetailController(parameter: Get.arguments));
  }
}
