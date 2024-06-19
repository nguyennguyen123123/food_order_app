import 'package:food_delivery_app/screen/table/create_and_order/create_and_order_controller.dart';
import 'package:get/get.dart';

class CreateAndOrderTableBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateAndOrderTableController(
          tableRepository: Get.find(),
          areaRepository: Get.find(),
        ));
  }
}
