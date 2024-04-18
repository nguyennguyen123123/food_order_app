import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_controller.dart';
import 'package:get/get.dart';

class EditOrderDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EditOrderDetailController(parameter: Get.arguments, orderRepository: Get.find()));
  }
}
