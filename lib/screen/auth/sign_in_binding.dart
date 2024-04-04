import 'package:food_delivery_app/screen/auth/sign_in_controller.dart';
import 'package:get/get.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignInController(
      authRepository: Get.find(),
      accountService: Get.find(),
    ));
  }
}
