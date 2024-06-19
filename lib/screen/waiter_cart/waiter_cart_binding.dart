import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_controller.dart';
import 'package:get/get.dart';

class WaiterCartBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      WaiterCartController(
        cartService: Get.find(),
        orderRepository: Get.find(),
        tableRepository: Get.find(),
        accountService: Get.find(),
        parameter: Get.arguments,
        printerService: Get.find(),
      ),
    );
  }
}
