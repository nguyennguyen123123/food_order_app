import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/screen/area/area_controller.dart';
import 'package:food_delivery_app/screen/area/area_parameter.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:get/get.dart';

class EditAreaController extends GetxController {
  final IAreaRepository areaRepository;
  final AreaParameter? parameter;

  Area? get tableParametar => parameter?.area;

  EditAreaController({required this.areaRepository, this.parameter});

  var isLoading = false.obs;

  late TextEditingController areaNameController;

  @override
  void onInit() {
    super.onInit();

    areaNameController = TextEditingController(text: tableParametar?.areaName.toString());
  }

  void editArea() async {
    final areaId = tableParametar?.areaId;
    if (areaId == null) return;

    try {
      isLoading(true);

      Area area = Area(
        areaId: areaId,
        areaName: areaNameController.text,
        createdAt: tableParametar?.createdAt,
      );

      final result = await areaRepository.editArea(area, areaId.toString());

      if (result != null) {
        Get.back();
        Get.find<AreaController>().updateTable(result);
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
    areaNameController.dispose();
  }
}
