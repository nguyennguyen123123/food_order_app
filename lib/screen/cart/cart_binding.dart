import 'package:food_delivery_app/screen/cart/cart_controller.dart';
import 'package:get/get.dart';

class CartBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartController(
          cartService: Get.find(),
        ));
  }
}
