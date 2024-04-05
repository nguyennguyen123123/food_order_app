import 'package:food_delivery_app/screen/admin/admin_controller.dart';
import 'package:get/get.dart';

class AdminBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AdminController(),
    );
  }
}
