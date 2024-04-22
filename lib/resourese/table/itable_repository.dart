import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class ITableRepository extends IBaseRepository {
  Future<Map<String, dynamic>?> addTable(TableModels tableModels);
  Future<List<TableModels>?> getTable();
  Future<TableModels?> editTable(String tableId, TableModels tableModels);
  Future<Map<String, dynamic>?> deleteTable(String tableId);
  Future<List<TableModels>> getListTableInOrder({String? areaId, int page = 0, int limit = LIMIT});
  Future<void> updateTableWithOrder(String tableNumber, {String? orderId});
  Future<TableModels?> getTableByNumber(String number);
}
