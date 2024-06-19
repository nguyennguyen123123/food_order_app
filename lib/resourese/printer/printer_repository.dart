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

  @override
  Future<List<Printer>> getPrinter() async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.PRINTER)
          .select()
          .withConverter((data) => data.map((e) => Printer.fromJson(e)).toList());

      return response;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<void> deletePrinter(String printerId) async {
    try {
      await baseService.client.from(TABLE_NAME.PRINTER).delete().eq('id', printerId);
    } catch (error) {
      print(error);
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Printer?> editPrinter(Printer printer, String printerId) async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.PRINTER)
          .update(printer.toJson())
          .eq('id', printerId)
          .select()
          .withConverter((data) => data.map((e) => Printer.fromJson(e)).toList());

      // if (response.error != null) {
      //   throw response.error!;
      // }

      return response.first;
    } catch (error) {
      handleError(error);

      return null;
    }
  }

  @override
  Future<void> log(String status, String error, String ip) async {
    await baseService.client.from(TABLE_NAME.PRINTER_LOG).insert({'status': status, 'error': error, 'printer_ip': ip});
  }
}
