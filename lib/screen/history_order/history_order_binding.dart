import 'package:food_delivery_app/screen/history_order/history_order_controller.dart';
import 'package:get/get.dart';

class HistoryOrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      HistoryOrderController(
        orderRepository: Get.find(),
      ),
    );
  }
}
