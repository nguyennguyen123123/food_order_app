import 'package:food_delivery_app/screen/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(
          baseService: Get.find(),
          authRepository: Get.find(),
          accountService: Get.find(),
        ));
  }
}
