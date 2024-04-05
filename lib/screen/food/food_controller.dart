import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FoodController extends GetxController {
  final IFoodRepository foodRepository;
  final AccountService accountService;

  FoodController({required this.foodRepository, required this.accountService});

  @override
  void onInit() {
    super.onInit();
    getListFood();
    getListFoodType();
  }

  var foodList = <FoodModel>[].obs;
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

  Future<void> getListFood() async {
    final data = await foodRepository.getFood();

    if (data != null) {
      foodList.assignAll(data);
    } else {
      foodList.clear();
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

  final nameController = TextEditingController();
  final desController = TextEditingController();
  final priceController = TextEditingController();

  final nameTypeController = TextEditingController();
  final desTypeController = TextEditingController();

  void onSubmit() async {
    // if (pickedImageNotifier.value != null) {
    //   final url = await foodRepository.updateImages(
    //     pickedImageNotifier.value!.path,
    //     pickedImageNotifier.value!,
    //     fileName: foodId,
    //   );

    //   print(url);
    // }

    if (nameController.text.isEmpty ||
        desController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedFoodType.value?.typeId == null ||
        pickedImageNotifier.value == null) return;

    try {
      final foodId = getUuid();

      final url = await foodRepository.updateImages(
        pickedImageNotifier.value!.path,
        pickedImageNotifier.value!,
        fileName: foodId,
      );

      FoodModel foodModel = FoodModel(
        foodId: foodId,
        name: nameController.text,
        description: desController.text,
        price: priceController.text,
        typeId: selectedFoodType.value?.typeId,
        image: url,
        createdAt: DateTime.now().toString(),
      );

      await foodRepository.addFood(foodModel);

      Get.back();
    } catch (error) {
      print('Error add food $error');
    }
  }

  void addTypeFood() async {
    if (nameTypeController.text.isEmpty || desTypeController.text.isEmpty) return;
    try {
      FoodType foodType = FoodType(
        typeId: getUuid(),
        name: nameTypeController.text,
        description: desTypeController.text,
        image: '',
        createdAt: DateTime.now().toString(),
      );

      await foodRepository.addTypeFood(foodType);

      Get.back();
    } catch (error) {
      print('Error add type $error');
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    desController.dispose();
    priceController.dispose();
    nameTypeController.dispose();
    desTypeController.dispose();
    pickedImageNotifier.value?.delete();
  }
}
