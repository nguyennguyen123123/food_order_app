import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FoodController extends GetxController {
  final IFoodRepository foodRepository;
  final AccountService accountService;
  final IPrinterRepository printerRepository;

  FoodController({required this.foodRepository, required this.accountService, required this.printerRepository});

  int page = 0;
  int limit = LIMIT;

  // final foodList = Rx<List<FoodModel>?>(null);
  final foodList = Rx<List<FoodModel>?>([]);

  @override
  void onInit() {
    super.onInit();
    onRefresh();
    getListFoodType();
    getPrinter();
  }

  var isLoadingFood = false.obs;
  var isLoadingAddFoodType = false.obs;

  var foodTypeList = <FoodType>[].obs;
  var selectedFoodType = Rx<FoodType?>(null);

  var printerList = <Printer>[].obs;
  List<Printer> selectedPrintersList = [];

  final ValueNotifier<File?> pickedImageNotifier = ValueNotifier<File?>(null);
  final ImagePicker imagePicker = ImagePicker();

  Future<void> imageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImageNotifier.value = File(pickedFile.path);
    }
  }

  Future<void> onRefresh() async {
    page = 0;
    foodList.value = null;
    final result = await foodRepository.getFood(page: page, limit: limit);

    foodList.value = result;
  }

  Future<bool> onLoadMoreFood() async {
    final length = (foodList.value ?? []).length;
    if (length < LIMIT * (page + 1)) return false;
    page += 1;

    final result = await foodRepository.getFood(page: page, limit: limit);

    foodList.update((val) => val?.addAll(result));
    if (result.length < limit) return false;
    return true;
  }

  Future<void> getListFoodType() async {
    final data = await foodRepository.getTypeFood();

    if (data != null) {
      foodTypeList.assignAll(data);
    } else {
      foodTypeList.clear();
    }
  }

  Future<void> getPrinter() async {
    final result = await printerRepository.getPrinter();

    printerList.assignAll(result);
  }

  void addSelectedPrinter(Printer printer) {
    selectedPrintersList.add(printer);
  }

  void removeSelectedPrinter(Printer printer) {
    selectedPrintersList.remove(printer);
  }

  final nameController = TextEditingController();
  final desController = TextEditingController();
  final priceController = TextEditingController();

  final nameTypeController = TextEditingController();
  final desTypeController = TextEditingController();

  void clearField() {
    nameController.text = '';
    desController.text = '';
    priceController.text = '';
    nameTypeController.text = '';
    desTypeController.text = '';
    pickedImageNotifier.value = null;
  }

  void onSubmit() async {
    if (nameController.text.isEmpty ||
        desController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedFoodType.value?.typeId == null ||
        pickedImageNotifier.value == null) return;

    try {
      isLoadingFood(true);

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
        price: double.tryParse(priceController.text.replaceAll(',', '')),
        typeId: selectedFoodType.value?.typeId,
        image: url,
        createdAt: DateTime.now().toString(),
      );

      await foodRepository.addFood(foodModel);
      await onRefresh();
      Get.back();

      nameController.clear();
      desController.clear();
      priceController.clear();
      pickedImageNotifier.value = null;
      selectedFoodType.value = null;

      isLoadingFood(false);
    } catch (error) {
      print('Error add food $error');
    } finally {
      isLoadingFood(false);
    }
  }

  Future<void> deleteFood(String foodId, int index) async {
    try {
      final delete = await foodRepository.deleteFood(foodId);
      if (delete != null) {
        foodList.update((val) => val?.removeAt(index));
        DialogUtils.showSuccessDialog(content: "delete_successful".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "delete_failed".tr);
      }
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "delete_failed".tr);
    }
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
      );

      await foodRepository.addTypeFood(foodType);

      Get.back();
      selectedFoodType.value = null;
      nameTypeController.clear();
      desTypeController.clear();

      isLoadingAddFoodType(false);
    } catch (error) {
      print('Error add type $error');
    } finally {
      isLoadingAddFoodType(false);
    }
  }

  // void addRandomFood() {
  //   return;
  //   List<String> image = [
  //     'https://loremflickr.com/300/300/food?lock=4937880604508160',
  //     'https://loremflickr.com/300/300/food?lock=8949018535133184',
  //     'https://loremflickr.com/300/300/food?lock=7622909170286592',
  //     'https://loremflickr.com/300/300/food?lock=8334778812071936',
  //     'https://loremflickr.com/300/300/food?lock=3172254500257792',
  //     'https://loremflickr.com/300/300/food?lock=6722631994703872',
  //     'https://loremflickr.com/300/300/food?lock=4625486086930432',
  //     'https://loremflickr.com/300/300/food?lock=7433888286638080',
  //     'https://loremflickr.com/300/300/food?lock=6524386555199488',
  //     'https://loremflickr.com/300/300/food?lock=7938470024577024',
  //     'https://loremflickr.com/300/300/food?lock=3863129979092992',
  //     'https://loremflickr.com/300/300/food?lock=8120058819641344',
  //     'https://loremflickr.com/300/300/food?lock=5019706029244416',
  //     'https://loremflickr.com/300/300/food?lock=8230113002913792',
  //     'https://loremflickr.com/300/300/food?lock=7937091950346240',
  //     'https://loremflickr.com/300/300/food?lock=1777698036776960',
  //     'https://loremflickr.com/300/300/food?lock=677730190360576',
  //     'https://loremflickr.com/300/300/food?lock=8599314869780480',
  //     'https://loremflickr.com/300/300/food?lock=3184442369638400',
  //     'https://loremflickr.com/300/300/food?lock=6599935749259264',
  //     'https://loremflickr.com/300/300/food?lock=3121382607028224',
  //     'https://loremflickr.com/300/300/food?lock=7909641145024512',
  //     'https://loremflickr.com/300/300/food?lock=1257597021716480',
  //     'https://loremflickr.com/300/300/food?lock=1948243212632064',
  //     'https://loremflickr.com/300/300/food?lock=799561375285248',
  //     'https://loremflickr.com/300/300/food?lock=8726670055833600',
  //     'https://loremflickr.com/300/300/food?lock=699522208497664',
  //     'https://loremflickr.com/300/300/food?lock=5079994128662528',
  //     'https://loremflickr.com/300/300/food?lock=2132034652733440',
  //     'https://loremflickr.com/300/300/food?lock=8752613549932544',
  //     'https://loremflickr.com/300/300/food?lock=7770698841849856',
  //     'https://loremflickr.com/300/300/food?lock=7108918643785728',
  //     'https://loremflickr.com/300/300/food?lock=3616439076388864',
  //     'https://loremflickr.com/300/300/food?lock=8573369897189376',
  //     'https://loremflickr.com/300/300/food?lock=5241114529366016',
  //     'https://loremflickr.com/300/300/food?lock=122275340746752',
  //     'https://loremflickr.com/300/300/food?lock=7271156115570688',
  //     'https://loremflickr.com/300/300/food?lock=7470840419450880',
  //     'https://loremflickr.com/300/300/food?lock=1832264495267840',
  //     'https://loremflickr.com/300/300/food?lock=3695542393634816',
  //     'https://loremflickr.com/300/300/food?lock=2346555847737344',
  //     'https://loremflickr.com/300/300/food?lock=605102144487424',
  //     'https://loremflickr.com/300/300/food?lock=6349895212466176',
  //     'https://loremflickr.com/300/300/food?lock=5961222759383040',
  //     'https://loremflickr.com/300/300/food?lock=4595951878537216',
  //     'https://loremflickr.com/300/300/food?lock=6376149965864960',
  //     'https://loremflickr.com/300/300/food?lock=8222638168080384',
  //     'https://loremflickr.com/300/300/food?lock=8237014721757184',
  //     'https://loremflickr.com/300/300/food?lock=5563696621289472',
  //     'https://loremflickr.com/300/300/food?lock=8466340801150976',
  //     'https://loremflickr.com/300/300/food?lock=4033209562038272',
  //     'https://loremflickr.com/300/300/food?lock=28482755100672',
  //     'https://loremflickr.com/300/300/food?lock=6498590614618112',
  //     'https://loremflickr.com/300/300/food?lock=7316014318485504',
  //     'https://loremflickr.com/300/300/food?lock=2627302796034048',
  //     'https://loremflickr.com/300/300/food?lock=1606167348379648',
  //     'https://loremflickr.com/300/300/food?lock=5740164139712512',
  //     'https://loremflickr.com/300/300/food?lock=4394051373629440',
  //     'https://loremflickr.com/300/300/food?lock=8697885140975616',
  //     'https://loremflickr.com/300/300/food?lock=644090867744768',
  //     'https://loremflickr.com/300/300/food?lock=327509476376576',
  //     'https://loremflickr.com/300/300/food?lock=997001820897280',
  //     'https://loremflickr.com/300/300/food?lock=89927083622400',
  //     'https://loremflickr.com/300/300/food?lock=7675545229721600',
  //     'https://loremflickr.com/300/300/food?lock=5821972776747008',
  //     'https://loremflickr.com/300/300/food?lock=2484044568723456',
  //     'https://loremflickr.com/300/300/food?lock=8935233309114368',
  //     'https://loremflickr.com/300/300/food?lock=8228061912760320',
  //     'https://loremflickr.com/300/300/food?lock=1435209587228672',
  //     'https://loremflickr.com/300/300/food?lock=8232761196281856',
  //     'https://loremflickr.com/300/300/food?lock=7023872392036352',
  //     'https://loremflickr.com/300/300/food?lock=3497463975510016',
  //     'https://loremflickr.com/300/300/food?lock=8179853641646080',
  //     'https://loremflickr.com/300/300/food?lock=3032437212839936',
  //     'https://loremflickr.com/300/300/food?lock=1044738956328960',
  //     'https://loremflickr.com/300/300/food?lock=7646871665246208',
  //     'https://loremflickr.com/300/300/food?lock=7519043185541120',
  //     'https://loremflickr.com/300/300/food?lock=1602798768619520',
  //     'https://loremflickr.com/300/300/food?lock=1736416912474112',
  //     'https://loremflickr.com/300/300/food?lock=8701955033530368',
  //     'https://loremflickr.com/300/300/food?lock=1961527359832064',
  //     'https://loremflickr.com/300/300/food?lock=635949274890240',
  //     'https://loremflickr.com/300/300/food?lock=2869396752039936',
  //     'https://loremflickr.com/300/300/food?lock=6150531582001152',
  //     'https://loremflickr.com/300/300/food?lock=4266747389542400',
  //     'https://loremflickr.com/300/300/food?lock=2246398091198464',
  //     'https://loremflickr.com/300/300/food?lock=6203059824754688',
  //     'https://loremflickr.com/300/300/food?lock=8877772170592256',
  //     'https://loremflickr.com/300/300/food?lock=4742927081275392',
  //     'https://loremflickr.com/300/300/food?lock=434954370547712',
  //     'https://loremflickr.com/300/300/food?lock=1524294752403456',
  //     'https://loremflickr.com/300/300/food?lock=2222958636433408',
  //     'https://loremflickr.com/300/300/food?lock=1270819208560640',
  //     'https://loremflickr.com/300/300/food?lock=7969419206590464',
  //     'https://loremflickr.com/300/300/food?lock=1801226706485248',
  //     'https://loremflickr.com/300/300/food?lock=8987379241058304',
  //     'https://loremflickr.com/300/300/food?lock=132951824138240',
  //     'https://loremflickr.com/300/300/food?lock=5421133675364352',
  //     'https://loremflickr.com/300/300/food?lock=5829592520589312',
  //     'https://loremflickr.com/300/300/food?lock=3941751951720448'
  //   ];
  //   excute(() => Future.wait(image.map((e) async {
  //         FoodModel foodModel = FoodModel(
  //           foodId: getUuid(),
  //           name: mockName(),
  //           description: mockString(100),
  //           price: Random().nextInt(100) + (Random().nextInt(99) / 100),
  //           typeId: foodTypeList[Random().nextInt(foodTypeList.length)].typeId,
  //           image: e,
  //           createdAt: DateTime.now().toIso8601String(),
  //         );
  //         await foodRepository.addFood(foodModel);
  //       })));
  // }

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
