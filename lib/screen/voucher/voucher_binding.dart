import 'package:food_delivery_app/screen/voucher/voucher_controller.dart';
import 'package:get/get.dart';

class VoucherBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => VoucherController(
        voucherepository: Get.find(),
      ),
    );
  }
}
