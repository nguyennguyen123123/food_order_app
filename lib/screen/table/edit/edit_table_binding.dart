import 'package:food_delivery_app/screen/table/edit/edit_table_controller.dart';
import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:get/get.dart';

class EditTableBinding implements Binding {
  @override
  void dependencies() {
    Get.put(
      EditTableController(
        parameter: Get.arguments,
        tableRepository: Get.find(),
      ),
    );
  }
}
