import 'package:food_delivery_app/screen/area/area_controller.dart';
import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:get/get.dart';

class AreaBinding implements Binding {
  @override
  void dependencies() {
    Get.put(
      AreaController(
        areaRepository: Get.find(),
      ),
    );
  }
}
