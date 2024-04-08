import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class PrinterController extends GetxController {
  final IPrinterRepository printerRepository;
  final AccountService accountService;

  PrinterController({required this.printerRepository, required this.accountService});

  void addPrinter() async {
    try {
      Printer printer = Printer(
        id: getUuid(),
        ip: '192.168.12.0',
        name: 'Test',
        port: '192',
      );

      await printerRepository.addPrinter(printer);
    } catch (error) {
      print(error);
    }
  }
}
