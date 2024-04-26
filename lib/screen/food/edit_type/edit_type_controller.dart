import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/printer_service.dart';
import 'package:food_delivery_app/screen/food/edit_type/edit_type_pramater.dart';
import 'package:food_delivery_app/screen/food/food_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditTypeController extends GetxController {
  final IFoodRepository foodRepository;
  final AccountService accountService;
  final PrinterService printerService;
  final EditTypeParameter? parameter;

  FoodType? get editType => parameter?.foodType;

  EditTypeController({
    required this.foodRepository,
    required this.accountService,
    required this.printerService,
    this.parameter,
  });

  List<Printer> get printers => printerService.printers.value;

  var foodTypeList = <FoodType>[].obs;
  var selectedFoodType = Rx<FoodType?>(null);

  final printerSelected = Rx<List<Printer>>([]);

  final ValueNotifier<File?> pickedImageNotifier = ValueNotifier<File?>(null);
  final ImagePicker imagePicker = ImagePicker();

  Future<void> imageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImageNotifier.value = File(pickedFile.path);
    }
  }

  late TextEditingController nameTypeController;
  late TextEditingController desTypeController;

  var isLoadingEditType = false.obs;

  @override
  void onInit() {
    super.onInit();
    getListFoodType();

    nameTypeController = TextEditingController(text: editType?.name);
    desTypeController = TextEditingController(text: editType?.description);

    printerSelected.value =
        editType?.printersIs.map((e) => printers.firstWhere((element) => element.id == e)).toList() ?? [];
  }

  Future<void> getListFoodType() async {
    final data = await foodRepository.getTypeFood();

    foodTypeList.value = data ?? <FoodType>[];
    selectedFoodType.value = foodTypeList.firstWhereOrNull((element) => element.typeId == parameter?.foodType?.typeId);
  }

  void addSelectedPrinter(Printer printer) {
    printerSelected.update((val) => val?.add(printer));
  }

  void removeSelectedPrinter(Printer printer) {
    printerSelected.update((val) => val?.removeWhere((ele) => ele.id == printer.id));
  }

  void editTypeFood() async {
    try {
      isLoadingEditType(true);

      final typeId = editType?.typeId ?? '';

      if (typeId.isEmpty) return;
      late String url;

      if (pickedImageNotifier.value?.path != null) {
        url = await foodRepository.updateImages(
          pickedImageNotifier.value!.path,
          pickedImageNotifier.value!,
          fileName: typeId,
        );
      }

      FoodType foodType = FoodType(
        typeId: typeId,
        parentTypeId: selectedFoodType.value?.typeId,
        name: nameTypeController.text,
        description: desTypeController.text,
        image: pickedImageNotifier.value?.path != null ? url : editType?.image,
        createdAt: DateTime.now().toString(),
        printersIs: printerSelected.value.map((e) => e.id ?? '').toList(),
      );

      await foodRepository.editTypeFood(typeId, foodType);

      int index = Get.find<FoodController>().foodTypeList.indexWhere((element) => element.typeId == foodType.typeId);
      if (index != -1) {
        Get.find<FoodController>().foodTypeList[index] = foodType;
      }

      Get.back();
    } catch (error) {
      print('Error add type $error');
    } finally {
      isLoadingEditType(false);
    }
  }
}
