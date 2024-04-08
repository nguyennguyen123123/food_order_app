import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class IPrinterRepository extends IBaseRepository {
  Future<Printer?> addPrinter(Printer printer);

}