import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class TableManageControlller extends GetxController {
  final ITableRepository tableRepository;
  final IAreaRepository areaRepository;
  final IOrderRepository orderRepository;

  TableManageControlller({required this.tableRepository, required this.areaRepository, required this.orderRepository});

  final TextEditingController tableNumberController = TextEditingController();

  var isLoadingAdd = false.obs;
  var isLoadingDelete = false.obs;
  var tableList = Rx<List<TableModels>?>(null);

  var areaTypeList = <Area>[].obs;

  var selectedAreaType = Rx<Area?>(null);

  final tablesArea = Rx<List<TableModels>?>([]);
  int page = 0;
  int limit = 50;
  @override
  void onInit() {
    super.onInit();
    getListArea();
    getListTable();
  }

  void clearAddTable() {
    tablesArea.value = [];
    selectedAreaType.value = null;
    tableNumberController.clear();
  }

  Future<void> getListTable() async {
    tableList.value = null;
    tableList.value = await tableRepository.getListTable(page: 0, limit: limit);
  }

  Future<bool> onLoadMoreTable() async {
    final length = tableList.value?.length ?? 0;
    if ((page + 1) * limit > length) return false;
    page += 1;
    final result = await await tableRepository.getListTable(page: 0, limit: limit);
    tableList.value = [...tableList.value!, ...result];
    if (result.length < limit) return false;
    return true;
  }

  Future<void> getListArea() async {
    final result = await areaRepository.getArea();

    areaTypeList.assignAll(result);
  }

  void onChangeSelectedArea(Area? area) async {
    selectedAreaType.value = area;
    tablesArea.value = null;
    tablesArea.value = await tableRepository.getTable(areaId: area?.areaId);
  }

  void addTable() async {
    if (tableNumberController.text.isEmpty || selectedAreaType.value?.areaId == null) return;

    try {
      isLoadingAdd(true);

      TableModels tableModels = TableModels(
        tableId: getUuid(),
        area: selectedAreaType.value,
        areaId: selectedAreaType.value?.areaId,
        tableNumber: tableNumberController.text.replaceAll(',', ''),
        createdAt: DateTime.now().toString(),
      );

      final result = await tableRepository.addTable(tableModels);

      if (result != null) {
        tableList.update((val) => val?.add(tableModels));
        // Get.find<TableControlller>().getListAreaTable(selectedAreaType.value?.areaId ?? '');
        Get.back();
        clearAddTable();
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
        tableList.update((val) => val?.removeWhere((table) => table.tableId == tableId));
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
      tableList.update((val) => val?[index] = updatedTable);
    }
  }

  @override
  void dispose() {
    super.dispose();
    tableNumberController.dispose();
  }
}
