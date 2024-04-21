import 'package:food_delivery_app/screen/table/manage/table_manage_controller.dart';
import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:get/get.dart';

class TableManageBinding implements Binding {
  @override
  void dependencies() {
    Get.put(
      TableManageControlller(
        orderRepository: Get.find(),
        tableRepository: Get.find(),
        areaRepository: Get.find(),
      ),
    );
  }
}
