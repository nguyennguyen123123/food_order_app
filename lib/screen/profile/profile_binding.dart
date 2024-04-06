import 'package:food_delivery_app/screen/home/main_controller.dart';
import 'package:food_delivery_app/screen/profile/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(ProfileController(
      profileRepository: Get.find(),
      accountService: Get.find(),
    ));
  }
}
