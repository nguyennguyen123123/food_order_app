import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/screen/food/edit_food/edit_food_parameter.dart';
import 'package:food_delivery_app/screen/food/food_controller.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditFoodController extends GetxController {
  final IFoodRepository foodRepository;
  final AccountService accountService;
  final EditFoodParameter? parameter;

  FoodModel? get editFoodModel => parameter?.foodModel;

  EditFoodController({required this.foodRepository, required this.accountService, this.parameter});

  var isLoading = false.obs;

  late TextEditingController nameController;
  late TextEditingController desController;
  late TextEditingController priceController;

  @override
  void onInit() {
    super.onInit();
    getListFoodType();

    nameController = TextEditingController(text: editFoodModel?.name ?? '');
    desController = TextEditingController(text: editFoodModel?.description ?? '');
    priceController = TextEditingController(text: Utils.getCurrency(editFoodModel?.price, removeCurrencyFormat: true));
  }

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

    foodTypeList.value = data ?? <FoodType>[];
    selectedFoodType.value =
        foodTypeList.firstWhereOrNull((element) => element.typeId == parameter?.foodModel?.foodType?.typeId);
  }

  void onEditFood() async {
    try {
      isLoading(true);

      final foodId = editFoodModel?.foodId ?? '';
      if (foodId.isEmpty) return;
      late String url;

      if (pickedImageNotifier.value?.path != null) {
        url = await foodRepository.updateImages(
          pickedImageNotifier.value!.path,
          pickedImageNotifier.value!,
          fileName: foodId,
        );
      }

      FoodModel foodModel = FoodModel(
        foodId: foodId,
        name: nameController.text,
        description: desController.text,
        price: double.tryParse(priceController.text.replaceAll(',', '')),
        typeId:
            selectedFoodType.value?.typeId != null ? selectedFoodType.value?.typeId : editFoodModel?.foodType?.typeId,
        image: pickedImageNotifier.value?.path != null ? url : editFoodModel?.image,
        createdAt: DateTime.now().toString(),
      );

      await foodRepository.editFood(foodId, foodModel);

      Get.back();
      Get.find<FoodController>().onRefresh();

      isLoading(false);
    } catch (error) {
      print('Error edit food $error');
    } finally {
      isLoading(false);
      Get.back();
      Get.find<FoodController>().onRefresh();
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    desController.dispose();
    priceController.dispose();
    pickedImageNotifier.dispose();
  }
}
