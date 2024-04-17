import 'package:food_delivery_app/screen/food_order_manage/food_order_manage_controller.dart';
import 'package:get/get.dart';

class FoodOrderManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      FoodOrderManageController(
        orderRepository: Get.find(),
        accountService: Get.find(),
      ),
    );
  }
}
