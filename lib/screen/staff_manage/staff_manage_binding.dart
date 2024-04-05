import 'package:food_delivery_app/screen/staff_manage/staff_manage_controller.dart';
import 'package:get/get.dart';

class StaffManageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StaffManageController());
  }
}
