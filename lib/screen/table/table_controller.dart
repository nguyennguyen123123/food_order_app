import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class TableControlller extends GetxController {
  final ITableRepository tableRepository;

  TableControlller({required this.tableRepository});

  final TextEditingController tableNumberController = TextEditingController();
  final TextEditingController numberOfOrderController = TextEditingController();
  final TextEditingController numberOfPeopleController = TextEditingController();

  var isLoadingAdd = false.obs;
  var isLoadingDelete = false.obs;
  var tableList = <TableModels>[].obs;

  void clear() {
    tableNumberController.clear();
    numberOfOrderController.clear();
    numberOfPeopleController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    getListTable();
  }

  void getListTable() async {
    final result = await tableRepository.getTable();

    if (result != null) {
      tableList.assignAll(result);
    } else {
      tableList.clear();
    }
  }

  void addTable() async {
    if (tableNumberController.text.isEmpty ||
        numberOfOrderController.text.isEmpty ||
        numberOfPeopleController.text.isEmpty) return;

    try {
      isLoadingAdd(true);

      TableModels tableModels = TableModels(
        tableId: getUuid(),
        tableNumber: int.tryParse(tableNumberController.text.replaceAll(',', '')),
        numberOfOrder: int.tryParse(numberOfOrderController.text.replaceAll(',', '')),
        numberOfPeople: int.tryParse(numberOfPeopleController.text.replaceAll(',', '')),
        createdAt: DateTime.now().toString(),
      );

      final result = await tableRepository.addTable(tableModels);

      if (result != null) {
        final table = TableModels.fromJson(result);

        tableList.add(table);
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
        tableList.removeWhere((table) => table.tableId == tableId);
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
    final index = tableList.indexWhere((table) => table.tableId == updatedTable.tableId);
    if (index != -1) {
      tableList[index] = updatedTable;
    }
  }

  @override
  void dispose() {
    super.dispose();
    tableNumberController.dispose();
    numberOfOrderController.dispose();
    numberOfPeopleController.dispose();
  }
}
