import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:get/get.dart';

class CreateAndOrderTableController extends GetxController {
  final ITableRepository tableRepository;
  final IAreaRepository areaRepository;

  CreateAndOrderTableController({
    required this.tableRepository,
    required this.areaRepository,
  });

  final TextEditingController tableNumberController = TextEditingController();

  var isLoadingAdd = false.obs;

  var areaTypeList = <Area>[].obs;

  var selectedAreaType = Rx<Area?>(null);
  final tablesArea = Rx<List<TableModels>?>([]);
  final currentTable = Rx<TableModels?>(null);

  @override
  void onInit() {
    super.onInit();
    getListArea();
    tableNumberController.addListener(() {
      if (currentTable.value != null && tableNumberController.text != currentTable.value?.tableNumber) {
        currentTable.value = null;
      }
    });
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

  void onSelectTable(TableModels? model) {
    currentTable.value = model;
    tableNumberController.text = model?.tableNumber ?? '';
  }

  void checkTable() async {
    if (tableNumberController.text.isEmpty) return;

    try {
      isLoadingAdd(true);
      if (currentTable.value != null && tableNumberController.text == currentTable.value?.tableNumber) {
        Get.back(result: currentTable.value);
        return;
      }
      final tableDetail = await tableRepository.isTableExist(tableNumberController.text);
      if (tableDetail != null) {
        Get.back(result: tableDetail);
        return;
      } else {
        DialogUtils.showInfoErrorDialog(content: "not_find_table".tr);
      }
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "failed_to_add_table".tr);
    } finally {
      isLoadingAdd(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    currentTable.close();
    tableNumberController.dispose();
  }
}
