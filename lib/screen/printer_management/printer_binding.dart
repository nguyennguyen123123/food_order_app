import 'package:food_delivery_app/screen/printer_management/printer_controller.dart';
import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:get/get.dart';

class PrinterBinding implements Binding {
  @override
  void dependencies() {
    Get.put(PrinterController(
      printerRepository: Get.find(),
      accountService: Get.find(),
    ));
  }
}
