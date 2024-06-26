import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class PrinterController extends GetxController {
  final IPrinterRepository printerRepository;
  final AccountService accountService;

  PrinterController({required this.printerRepository, required this.accountService});

  final ipController = TextEditingController();
  final nameControler = TextEditingController();
  final portController = TextEditingController();

  var isLoadingAdd = false.obs;
  var isLoadingDelete = false.obs;

  var printer = <Printer>[].obs;

  @override
  void onInit() {
    super.onInit();
    getPrinter();
  }

  Future<void> getPrinter() async {
    final result = await printerRepository.getPrinter();

    // printer.value = result as List<Printer>;

    printer.assignAll(result);
  }

  void addPrinter() async {
    if (ipController.text.isEmpty || nameControler.text.isEmpty || portController.text.isEmpty) return;

    try {
      isLoadingAdd(true);

      Printer printer = Printer(
        id: getUuid(),
        ip: ipController.text,
        name: nameControler.text,
        port: portController.text,
      );

      await printerRepository.addPrinter(printer);
      getPrinter();
      Get.back();

      ipController.clear();
      nameControler.clear();
      portController.clear();
      isLoadingAdd(false);
    } catch (error) {
      print(error);
    } finally {
      isLoadingAdd(false);
    }
  }

  Future<void> deletePrinter(String printerId) async {
    try {
      isLoadingDelete(true);

      await printerRepository.deletePrinter(printerId);
      printer.removeWhere((print) => print.id == printerId);

      isLoadingDelete(false);
    } catch (error) {
      print('Error delete food: $error');
    } finally {
      isLoadingDelete(false);
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
