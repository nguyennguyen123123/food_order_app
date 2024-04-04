import 'package:food_delivery_app/screen/temp/_controller.dart';
import 'package:get/get.dart';

class Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Controller());
  }
}
