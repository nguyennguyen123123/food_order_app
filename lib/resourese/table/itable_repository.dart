import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class ITableRepository extends IBaseRepository {
  Future<Map<String, dynamic>?> addTable(TableModels tableModels);
  Future<List<TableModels>?> getTable();
  Future<TableModels?> editTable(String tableId, TableModels tableModels);
  Future<Map<String, dynamic>?> deleteTable(String tableId);
}
