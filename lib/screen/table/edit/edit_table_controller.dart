import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:food_delivery_app/screen/table/table_parameter.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:get/get.dart';

class EditTableController extends GetxController {
  final ITableRepository tableRepository;
  final TableParameter? parameter;

  TableModels? get tableParametar => parameter?.tableModels;

  EditTableController({required this.tableRepository, this.parameter});

  var isLoading = false.obs;

  late TextEditingController tableNumberController;

  @override
  void onInit() {
    super.onInit();

    tableNumberController = TextEditingController(text: tableParametar?.tableNumber.toString());
  }

  void editTable() async {
    final tableId = tableParametar?.tableId;
    if (tableId == null) return;

    try {
      isLoading(true);
      TableModels tableModels = TableModels(
        tableId: tableId,
        tableNumber: tableNumberController.text.replaceAll(',', ''),
        createdAt: tableParametar?.createdAt,
      );

      final result = await tableRepository.editTable(tableId.toString(), tableModels);

      if (result != null) {
        Get.back();
        Get.find<TableControlller>().updateTable(result);
        DialogUtils.showSuccessDialog(content: "edit_successfully".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "edit_failed".tr);
      }

      isLoading(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "edit_failed".tr);
    } finally {
      isLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    tableNumberController.dispose();
  }
}
