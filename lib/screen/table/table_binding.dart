import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:get/get.dart';

class TableBinding implements Binding {
  @override
  void dependencies() {
    Get.put(
      TableControlller(
        tableRepository: Get.find(),
      ),
    );
  }
}
