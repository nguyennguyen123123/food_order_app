import 'package:food_delivery_app/screen/area/edit/edit_table_controller.dart';
import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:get/get.dart';

class EditAreaBinding implements Binding {
  @override
  void dependencies() {
    Get.put(
      EditAreaController(
        parameter: Get.arguments,
        areaRepository: Get.find(),
      ),
    );
  }
}
