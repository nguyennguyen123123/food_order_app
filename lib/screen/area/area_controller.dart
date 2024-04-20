import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AreaController extends GetxController {
  final IAreaRepository areaRepository;

  AreaController({required this.areaRepository});

  final TextEditingController areaNameController = TextEditingController();

  var isLoadingAdd = false.obs;
  var isLoadingDelete = false.obs;
  var areaList = Rx<List<Area>?>(null);

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  Future<void> onRefresh() async {
    areaList.value = null;

    final result = await areaRepository.getArea();

    areaList.value = result;
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

        areaList.value?.add(area);
        Get.back();
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
        areaList.value?.removeWhere((table) => table.areaId == areaId);
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

  void updateTable(Area updatedArea) {
    final index = areaList.value?.indexWhere((table) => table.areaId == updatedArea.areaId) ?? -1;
    if (index != -1) {
      areaList.value![index] = updatedArea;
    }
  }

  @override
  void dispose() {
    super.dispose();
    areaNameController.dispose();
  }
}
