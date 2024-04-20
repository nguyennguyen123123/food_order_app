import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_parameter.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_response.dart';
import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_parameter.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class TableControlller extends GetxController {
  final ITableRepository tableRepository;
  final IAreaRepository areaRepository;

  TableControlller({required this.tableRepository, required this.areaRepository});

  final TextEditingController tableNumberController = TextEditingController();

  var isLoadingAdd = false.obs;
  var isLoadingDelete = false.obs;
  var tableList = Rx<List<TableModels>?>(null);

  var areaTypeList = <Area>[].obs;

  var selectedAreaType = Rx<Area?>(null);

  void clear() {
    tableNumberController.clear();
  }

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
        table.foodOrder = result;
        tableList.update((val) {
          final index = val?.indexWhere((element) => element.tableId == table.tableId) ?? -1;
          if (index != -1) {
            val?[index] = table;
          }
        });
      }
    } else {
      final result =
          await Get.toNamed(Routes.EDIT_ORDER, arguments: EditOrderDetailParameter(foodOrder: table.foodOrder!));
      if (result != null && result is EditOrderResponse) {
        final tables = tableList.value ?? <TableModels>[];
        if (result.type == EditType.CHANGE_WHOLE_ORDER_TABLE) {
          final oldIndex = tables.indexWhere((element) => element.tableNumber == table.tableNumber);
          if (oldIndex != -1) {
            tables[oldIndex].foodOrder = null;
          }
          final newIndex =
              tables.indexWhere((element) => element.tableNumber == (int.tryParse(result.foodOrder.tableNumber!) ?? 0));
          if (newIndex != -1) {
            tables[newIndex].foodOrder = result.foodOrder;
          }
        }
        tableList.value = tables;
        tableList.refresh();
      }
    }
  }

  void addTable() async {
    if (tableNumberController.text.isEmpty || selectedAreaType.value?.areaId == null) return;

    try {
      isLoadingAdd(true);

      TableModels tableModels = TableModels(
        tableId: getUuid(),
        areaId: selectedAreaType.value?.areaId,
        tableNumber: tableNumberController.text.replaceAll(',', ''),
        createdAt: DateTime.now().toString(),
      );

      final result = await tableRepository.addTable(tableModels);

      if (result != null) {
        final table = TableModels.fromJson(result);

        tableList.value?.add(table);
        Get.back();
        clear();
        DialogUtils.showSuccessDialog(content: "successfully_added_new_table".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "table_number_already_exists_text".tr);
      }
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "failed_to_add_table".tr);
    } finally {
      isLoadingAdd(false);
    }
  }

  Future<void> deleteTable(String tableId) async {
    try {
      isLoadingDelete(true);

      final delete = await tableRepository.deleteTable(tableId);
      if (delete != null) {
        tableList.value?.removeWhere((table) => table.tableId == tableId);
        Get.back();
        DialogUtils.showSuccessDialog(content: "table_deleted_successfully".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "failed_to_delete_table".tr);
      }
    } catch (error) {
      DialogUtils.showInfoErrorDialog(content: "failed_to_delete_table".tr);
    } finally {
      isLoadingDelete(false);
    }
  }

  void updateTable(TableModels updatedTable) {
    final index = tableList.value?.indexWhere((table) => table.tableId == updatedTable.tableId) ?? -1;
    if (index != -1) {
      tableList.value![index] = updatedTable;
    }
  }

  @override
  void dispose() {
    super.dispose();
    tableNumberController.dispose();
  }
}
