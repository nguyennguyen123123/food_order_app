import 'package:food_delivery_app/screen/printer/edit/edit_printer_controller.dart';
import 'package:food_delivery_app/screen/temp/_binding.dart';
import 'package:get/get.dart';

class EditPrinterBinding implements Binding {
  @override
  void dependencies() {
    Get.put(EditPrinterController(
      parameter: Get.arguments,
      printerRepository: Get.find(),
      accountService: Get.find(),
    ));
  }
}
