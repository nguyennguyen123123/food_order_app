import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/printer_service.dart';
import 'package:food_delivery_app/screen/food/type_food/upsert_type_food_parameter.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpsertTypeFoodController extends GetxController {
  final IFoodRepository foodRepository;
  final AccountService accountService;
  final PrinterService printerService;
  final UpsertTypeFoodParameter? parameter;

  UpsertTypeFoodController({
    required this.foodRepository,
    required this.accountService,
    required this.printerService,
    this.parameter,
  });

  int page = 0;
  int limit = LIMIT;

  List<Printer> get printers => printerService.printers.value;
  final printerSelected = Rx<List<Printer>>([]);
  final foodList = Rx<List<FoodModel>?>([]);

  final nameTypeController = TextEditingController();
  final desTypeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getListFoodType();
    if (parameter?.foodType != null) {
      nameTypeController.text = parameter?.foodType?.name ?? '';
      desTypeController.text = parameter?.foodType?.description ?? '';
    }
  }

  var isLoadingFood = false.obs;
  var isLoadingAddFoodType = false.obs;

  var foodTypeList = <FoodType>[].obs;
  var selectedFoodType = Rx<FoodType?>(null);

  final ValueNotifier<File?> pickedImageNotifier = ValueNotifier<File?>(null);
  final ImagePicker imagePicker = ImagePicker();

  Future<void> imageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImageNotifier.value = File(pickedFile.path);
    }
  }

  Future<void> getListFoodType() async {
    final data = await foodRepository.getTypeFood();

    if (data != null) {
      foodTypeList.assignAll(data);
    } else {
      foodTypeList.clear();
    }
  }

  void addSelectedPrinter(Printer printer) {
    final index = printerSelected.value.indexWhere((element) => element.id == printer.id);
    if (index != -1) return;
    printerSelected.update((val) => val?.add(printer));
  }

  void removeSelectedPrinter(Printer printer) {
    printerSelected.update((val) => val?.removeWhere((ele) => ele.id == printer.id));
  }

  void addTypeFood() async {
    if (nameTypeController.text.isEmpty || desTypeController.text.isEmpty) return;
    try {
      isLoadingAddFoodType(true);

      final typeId = getUuid();

      final url = pickedImageNotifier.value != null
          ? await foodRepository.updateImages(
              pickedImageNotifier.value!.path,
              pickedImageNotifier.value!,
              fileName: typeId,
            )
          : '';

      FoodType foodType = FoodType(
        typeId: typeId,
        parentTypeId: selectedFoodType.value?.typeId,
        name: nameTypeController.text,
        description: desTypeController.text,
        image: url,
        createdAt: DateTime.now().toString(),
        printersIs: printerSelected.value.map((e) => e.id ?? '').toList(),
      );

      await foodRepository.addTypeFood(foodType);

      Get.back();
    } catch (error) {
      print('Error add type $error');
    } finally {
      isLoadingAddFoodType(false);
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameTypeController.dispose();
    desTypeController.dispose();
    pickedImageNotifier.value?.delete();
  }
}
