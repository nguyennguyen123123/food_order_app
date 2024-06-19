import 'package:food_delivery_app/screen/check_in_out/check_in_out_controller.dart';
import 'package:get/get.dart';

class CheckInOutBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CheckInOutController(
      profileRepository: Get.find(),
      checkInOutRepository: Get.find(),
      accountService: Get.find(),
    ));
  }
}
