import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';

class PrinterRepository extends IPrinterRepository {
  final BaseService baseService;

  PrinterRepository({required this.baseService});

  @override
  Future<Printer?> addPrinter(Printer printer) async {
    try {
      final response = await baseService.client.from(TABLE_NAME.PRINTER).insert(printer.toJson());

      return response;
    } catch (e) {
      print(e);
      handleError(e);

      return null;
    }
  }
}
