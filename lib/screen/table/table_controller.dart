import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_parameter.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_response.dart';
import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_parameter.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class TableControlller extends GetxController {
  final ITableRepository tableRepository;
  final IAreaRepository areaRepository;
  final IOrderRepository orderRepository;
  final OrderCartService cartService;

  TableControlller({
    required this.tableRepository,
    required this.areaRepository,
    required this.orderRepository,
    required this.cartService,
  });

  final tableList = Rx<List<TableModels>?>(null);

  final areaTypeList = <Area>[].obs;
  final currentAreaId = Rx<String>('');
  int page = 0;
  final limit = 50;

  @override
  void onClose() {
    tableList.close();
    areaTypeList.close();
    currentAreaId.close();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    getListTable();
    getListArea();
  }

  Future<void> getListTable() async {
    tableList.value = null;
    page = 0;
    tableList.value = await tableRepository.getListTableInOrder(areaId: currentAreaId.value, page: page, limit: limit);
  }

  Future<void> getListArea() async {
    final result = await areaRepository.getArea();
    areaTypeList.assignAll(result);
  }

  void navigateToOrderInTable(TableModels table) async {
    if (table.foodOrder == null) {
      final result =
          await Get.toNamed(Routes.WAITER_CART, arguments: WaiterCartParameter(tableNumber: table.tableNumber ?? ''));
      cartService.clearCart();
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
        showLoading();
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
            } else {
              tables.add(targetTable);
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
        dissmissLoading();
      }
    }
  }

  void onRefreshTable(String tableNumber) async {
    if (tableNumber.isNotEmpty) {
      final tables = tableList.value ?? <TableModels>[];
      final table = await tableRepository.getTableByNumber(tableNumber);
      if (table != null) {
        final oldIndex = tables.indexWhere((element) => element.tableNumber == tableNumber);
        if (oldIndex != -1) {
          tables[oldIndex] = table;
        }
        tableList.value = tables;
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
    currentAreaId.value = areaId;
    getListTable();
  }

  Future<bool> onLoadMore() async {
    final length = tableList.value?.length ?? 0;
    if ((page + 1) * limit > length) return false;
    page += 1;
    final result = await tableRepository.getListTableInOrder(areaId: currentAreaId.value, page: page, limit: limit);
    tableList.value = [...tableList.value!, ...result];
    if (result.length < limit) return false;
    return true;
  }
}
