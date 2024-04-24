import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
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

  void clear() {
    tableNumberController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    getListArea();
    getListTable();
  }

  Future<void> getListTable() async {
    tableList.value = null;
    tableList.value = await tableRepository.getListTableInOrder();
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
        areaId: selectedAreaType.value?.areaId,
        tableNumber: tableNumberController.text.replaceAll(',', ''),
        createdAt: DateTime.now().toString(),
      );

      final result = await tableRepository.addTable(tableModels);

      if (result != null) {
        final table = TableModels.fromJson(result);

        tableList.value?.add(table);
        Get.find<TableControlller>().getListAreaTable(selectedAreaType.value?.areaId ?? '');
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
