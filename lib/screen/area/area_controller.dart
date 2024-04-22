import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AreaController extends GetxController {
  final IAreaRepository areaRepository;

  AreaController({required this.areaRepository});

  final TextEditingController areaNameController = TextEditingController();

  var isLoadingAdd = false.obs;
  var isLoadingDelete = false.obs;
  var areaList = <Area>[].obs;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  Future<void> onRefresh() async {
    final result = await areaRepository.getArea();

    areaList.assignAll(result);
  }

  Future<void> addArea() async {
    if (areaNameController.text.isEmpty) return;
    try {
      isLoadingAdd(true);

      Area area = Area(
        areaId: getUuid(),
        areaName: areaNameController.text,
        createdAt: DateTime.now().toString(),
      );

      final result = await areaRepository.addArea(area);

      if (result != null) {
        final area = Area.fromJson(result);

        areaList.add(area);
        Get.back();
        Get.find<TableControlller>().getListArea();
        areaNameController.clear();
        DialogUtils.showSuccessDialog(content: "add_new_area_successfully".tr);
      }

      isLoadingAdd(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "add_area_failed".tr);
    } finally {
      isLoadingAdd(false);
    }
  }

  Future<void> deleteTable(String areaId) async {
    try {
      isLoadingDelete(true);

      final delete = await areaRepository.deleteArea(areaId);
      if (delete != null) {
        areaList.removeWhere((table) => table.areaId == areaId);
        Get.find<TableControlller>().getListArea();
        Get.back();
        DialogUtils.showSuccessDialog(content: "delete_area_successfully".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "delete_area_failed".tr);
      }
    } catch (error) {
      DialogUtils.showInfoErrorDialog(content: "delete_area_failed".tr);
    } finally {
      isLoadingDelete(false);
    }
  }

  void updateArea(Area updatedArea) {
    final index = areaList.indexWhere((table) => table.areaId == updatedArea.areaId);
    if (index != -1) {
      areaList[index] = updatedArea;
    }
  }

  @override
  void dispose() {
    super.dispose();
    areaNameController.dispose();
  }
}
