import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/screen/printer/printer_controller.dart';
import 'package:food_delivery_app/screen/printer/printer_parameter.dart';
import 'package:get/get.dart';

class EditPrinterController extends GetxController {
  final IPrinterRepository printerRepository;
  final AccountService accountService;
  final PrinterParameter? parameter;

  Printer? get printerParametar => parameter?.printer;

  EditPrinterController({required this.printerRepository, required this.accountService, this.parameter});

  late TextEditingController ipController;
  late TextEditingController nameControler;
  late TextEditingController portController;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    ipController = TextEditingController(text: printerParametar?.ip);
    nameControler = TextEditingController(text: printerParametar?.name);
    portController = TextEditingController(text: printerParametar?.port);
  }

  void editPrinter() async {
    final printerId = printerParametar?.id;
    if (printerId == null) return;

    try {
      isLoading(true);

      Printer printer = Printer(
        id: printerId,
        name: nameControler.text,
        ip: ipController.text,
        port: portController.text,
      );

      await printerRepository.editPrinter(printer, printerId);

      Get.back();
      Get.find<PrinterController>().getPrinter();

      isLoading(false);
    } catch (error) {
    } finally {
      isLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    ipController.dispose();
    nameControler.dispose();
    portController.dispose();
  }
}
