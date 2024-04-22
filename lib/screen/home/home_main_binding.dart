import 'package:food_delivery_app/screen/home/home_controller.dart';
import 'package:food_delivery_app/screen/home/main_controller.dart';
import 'package:food_delivery_app/screen/profile/profile_controller.dart';
import 'package:food_delivery_app/screen/table/manage/table_manage_controller.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:get/get.dart';

class HomeMainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MainController(cartService: Get.find()));
    Get.put(HomeController(foodRepository: Get.find(), cartService: Get.find()));
    Get.put(ProfileController(profileRepository: Get.find(), accountService: Get.find()));
    // Get.put(CartController(
    //   cartService: Get.find(),
    //   orderRepository: Get.find(),
    //   tableRepository: Get.find(),
    //   accountService: Get.find(),
    // ));
    Get.put(TableControlller(
      tableRepository: Get.find(),
      orderRepository: Get.find(),
      areaRepository: Get.find(),
      cartService: Get.find(),
    ));
    Get.put(TableManageControlller(
      areaRepository: Get.find(),
      orderRepository: Get.find(),
      tableRepository: Get.find(),
    ));
  }
}
