import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_parameter.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_response.dart';
import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_parameter.dart';
import 'package:get/get.dart';

class TableControlller extends GetxController {
  final ITableRepository tableRepository;
  final IAreaRepository areaRepository;
  final IOrderRepository orderRepository;

  TableControlller({required this.tableRepository, required this.areaRepository, required this.orderRepository});

  var tableList = Rx<List<TableModels>?>(null);

  var areaTypeList = <Area>[].obs;

  var listAreaTable = <TableModels>[].obs;

  @override
  void onInit() {
    super.onInit();
    getListTable();
    getListArea();
  }

  Future<void> getListTable() async {
    tableList.value = null;
    tableList.value = await tableRepository.getListTableInOrder();
  }

  Future<void> getListArea() async {
    final result = await areaRepository.getArea();

    areaTypeList.assignAll(result);
  }

  void navigateToOrderInTable(TableModels table) async {
    if (table.foodOrder == null) {
      final result =
          await Get.toNamed(Routes.WAITER_CART, arguments: WaiterCartParameter(tableNumber: table.tableNumber ?? ''));
      if (result != null && result is FoodOrder) {
        table.foodOrder = await orderRepository.getOrderDetail(result.orderId ?? '');
        tableList.update((val) {
          final index = val?.indexWhere((element) => element.tableId == table.tableId) ?? -1;
          if (index != -1) {
            val?[index] = table;
          }
        });
      }
    } else {
      final result = await Get.toNamed(Routes.EDIT_ORDER,
          arguments: EditOrderDetailParameter(foodOrder: table.foodOrder!.copyWith()));
      if (result != null && result is EditOrderResponse) {
        final tables = tableList.value ?? <TableModels>[];
        if (result.type == EditType.CHANGE_TABLE) {
          final originalTable = await tableRepository.getTableByNumber(result.orignalTable);
          final targetTable = await tableRepository.getTableByNumber(result.targetTable);

          if (originalTable != null) {
            final oldIndex = tables.indexWhere((element) => element.tableNumber == result.orignalTable);
            if (oldIndex != -1) {
              tables[oldIndex] = originalTable;
            }
          }
          if (targetTable != null) {
            final newIndex = tables.indexWhere((element) => element.tableNumber == result.targetTable);
            if (newIndex != -1) {
              tables[newIndex] = targetTable;
            }
          }
        } else {
          final table = await tableRepository.getTableByNumber(result.orignalTable);
          if (table != null) {
            final oldIndex = tables.indexWhere((element) => element.tableNumber == result.orignalTable);
            if (oldIndex != -1) {
              tables[oldIndex] = table;
            }
          }
        }
        tableList.value = tables;
        tableList.refresh();
      }
    }
  }

  void updateTable(TableModels updatedTable) {
    final index = tableList.value?.indexWhere((table) => table.tableId == updatedTable.tableId) ?? -1;
    if (index != -1) {
      tableList.value![index] = updatedTable;
    }
  }

  Future<void> getListAreaTable(String areaId) async {
    final result = await tableRepository.getListAreaTable(areaId);

    listAreaTable.assignAll(result!);
  }
}
