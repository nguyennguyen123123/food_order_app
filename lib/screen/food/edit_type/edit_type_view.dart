import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/screen/food/edit_type/edit_type_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class EditTypeView extends GetWidget<EditTypeController> {
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
              Text('edit_food_type'.tr, style: StyleThemeData.bold18(height: 0)),
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
                                width: 24.w,
                                height: 24.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : controller.editType.image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 150.w,
                                  height: 150.h,
                                  child: Image.network(
                                    controller.editType.image ?? '',
                                    width: 24.w,
                                    height: 24.h,
                                    fit: BoxFit.cover,
                                  ),
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
                Align(alignment: Alignment.centerLeft, child: Text('food_type'.tr, style: StyleThemeData.bold14())),
                SizedBox(height: 4.h),
                Obx(
                  () => Container(
                    width: MediaQuery.of(context).size.width.w,
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
                SizedBox(height: 8.h),
                Align(alignment: Alignment.centerLeft, child: Text('printer'.tr, style: StyleThemeData.bold14())),
                SizedBox(height: 4.h),
                Container(
                  width: MediaQuery.of(context).size.width.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: appTheme.blackColor, width: 1),
                  ),
                  padding: padding(horizontal: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Printer>(
                      hint: Text('select_printer'.tr, style: StyleThemeData.regular16()),
                      // value: controller.selectedPrinterType.value,
                      onChanged: (Printer? newValue) {
                        if (newValue != null) {
                          controller.addSelectedPrinter(newValue);
                        }
                      },
                      items: controller.printers.map((Printer type) {
                        return DropdownMenuItem<Printer>(
                          value: type,
                          child: Text(type.name ?? ''),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => controller.printerSelected.value.isNotEmpty
                      ? Row(
                          children: controller.printerSelected.value
                              .map(
                                (print) => Stack(
                                  children: [
                                    Container(
                                      padding: padding(all: 8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[200],
                                      ),
                                      child: Text(print.name ?? '', style: StyleThemeData.bold14()),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          controller.removeSelectedPrinter(print);
                                        },
                                        icon: Icon(Icons.close),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        )
                      : Container(),
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.nameTypeController,
                  hintText: 'category_name'.tr,
                  label: 'category_name'.tr,
                  suffix: Icon(Icons.title),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.desTypeController,
                  hintText: 'category_description'.tr,
                  label: 'category_description'.tr,
                  suffix: Icon(Icons.description),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => ConfirmationButtonWidget(
                    isLoading: controller.isLoadingEditType.isTrue,
                    onTap: controller.editTypeFood,
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
