import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/screen/food/edit_food/edit_food_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/number_formatter.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class EditFoodView extends GetWidget<EditFoodController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.transparentColor,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: appTheme.blackColor),
              ),
              Text('edit_food'.tr, style: StyleThemeData.bold18(height: 0)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: padding(all: 16),
            child: Column(
              children: [
                ValueListenableBuilder<File?>(
                  valueListenable: controller.pickedImageNotifier,
                  builder: (context, pickedImage, _) {
                    return pickedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 150.w,
                              height: 150.h,
                              child: Image.file(
                                pickedImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : controller.editFoodModel?.image != null
                            ? SizedBox(
                                width: 150.w,
                                height: 150.h,
                                child: CachedNetworkImage(
                                  imageUrl: controller.editFoodModel?.image ?? '',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 150.w,
                                height: 150.h,
                                alignment: Alignment.center,
                                padding: padding(vertical: 32, horizontal: 24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: appTheme.backgroundContainer,
                                ),
                                child: Text('select_image'.tr, style: StyleThemeData.regular14()),
                              );
                  },
                ),
                ElevatedButton(
                  onPressed: controller.imageFromGallery,
                  child: Text('select_image'.tr, style: StyleThemeData.regular14()),
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.nameController,
                  hintText: 'food_name'.tr,
                  label: 'food_name'.tr,
                  suffix: Icon(Icons.title),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.desController,
                  hintText: 'food_description'.tr,
                  label: 'food_description'.tr,
                  suffix: Icon(Icons.description),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.priceController,
                  hintText: 'food_price'.tr,
                  label: 'food_price'.tr,
                  suffix: Icon(Icons.price_change),
                  textInputType: TextInputType.number,
                  numberFormat: NumericTextFormatter(),
                ),
                SizedBox(height: 8.h),
                Align(alignment: Alignment.centerLeft, child: Text('food_type'.tr, style: StyleThemeData.bold14())),
                SizedBox(height: 4.h),
                Obx(
                  () => Container(
                    width: Get.size.width.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: appTheme.blackColor, width: 1),
                    ),
                    padding: padding(horizontal: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<FoodType>(
                        hint: Text('select_category'.tr, style: StyleThemeData.regular16()),
                        value: controller.selectedFoodType.value,
                        onChanged: (FoodType? newValue) {
                          controller.selectedFoodType.value = newValue!;
                        },
                        items: controller.foodTypeList.map((FoodType type) {
                          return DropdownMenuItem<FoodType>(
                            value: type,
                            child: Text(type.name ?? ''),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => ConfirmationButtonWidget(
                    isLoading: controller.isLoading.isTrue,
                    onTap: controller.onEditFood,
                    text: 'edit'.tr,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
