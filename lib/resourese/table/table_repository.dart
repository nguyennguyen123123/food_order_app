import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';

class TableRepository extends ITableRepository {
  final BaseService baseService;

  TableRepository({required this.baseService});

  String get fullQueryTableOrder {
    const queryOrder = 'order_item!inner (*, food_id:food!inner(*, typeId(*))))';
    return '''
          *, 
          area_id(*),
          order(*, 
          user_order_id(*),
          ${TABLE_NAME.ORDER_WITH_PARTY}!inner(party_order!inner(*, party_order_item!inner($queryOrder)))),
          ''';
  }

  @override
  Future<Map<String, dynamic>?> addTable(TableModels tableModels) async {
    try {
      final Map<String, dynamic>? existingTables = await baseService.client
          .from(TABLE_NAME.TABLE)
          .select()
          .eq('table_number', tableModels.tableNumber.toString())
          .maybeSingle();

      if (existingTables != null) {
        return null;
      }

      final List<Map<String, dynamic>> response =
          await baseService.client.from(TABLE_NAME.TABLE).insert(tableModels.toJson()).select();

      return response.first;
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<List<TableModels>?> getTable() async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.TABLE)
          .select("*, area_id(*)")
          .withConverter((data) => data.map((e) => TableModels.fromJson(e)).toList());

      return response.toList();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<TableModels?> editTable(String tableId, TableModels tableModels) async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.TABLE)
          .update(tableModels.toJson())
          .eq('table_id', tableId)
          .select()
          .withConverter((data) => data.map((e) => TableModels.fromJson(e)).toList());

      return response.first;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> deleteTable(String tableId) async {
    try {
      final data = await baseService.client.from(TABLE_NAME.TABLE).delete().match({'table_id': tableId}).select();

      return data.first;
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<List<TableModels>> getListTableInOrder({String? areaId, int page = 0, int limit = LIMIT}) async {
    try {
      var query = baseService.client.from(TABLE_NAME.TABLE).select(fullQueryTableOrder);
      if ((areaId ?? '').isNotEmpty) {
        query = query.eq('area_id', areaId!);
      }
      final response = await query
          .limit(limit)
          .range(page * limit, (page + 1) * limit)
          .withConverter((data) => data.map((e) => TableModels.fromJson(e)).toList());

      return response.toList();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<void> updateTableWithOrder(String tableNumber, {String? orderId}) async {
    try {
      await baseService.client.from(TABLE_NAME.TABLE).update({'order': orderId}).eq('table_number', tableNumber);
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<TableModels?> getTableByNumber(String number) async {
    try {
      final result = await baseService.client
          .from(TABLE_NAME.TABLE)
          .select(fullQueryTableOrder)
          .eq('table_number', number)
          .withConverter((data) => data.map((e) => TableModels.fromJson(e)).toList());
      return result.first;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
