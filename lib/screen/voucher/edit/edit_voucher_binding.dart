import 'package:food_delivery_app/screen/voucher/edit/edit_voucher_controller.dart';
import 'package:get/get.dart';

class EditVoucherBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => EditVoucherController(
        parameter: Get.arguments,
        voucherepository: Get.find(),
      ),
    );
  }
}
