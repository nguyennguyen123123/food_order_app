import 'package:food_delivery_app/screen/staff_in_working/staff_in_working_controller.dart';
import 'package:get/get.dart';

class StaffInWorkingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(StaffInWorkingController(
      accountService: Get.find(),
      authRepository: Get.find(),
      summarizeRepository: Get.find(),
    ));
  }
}
