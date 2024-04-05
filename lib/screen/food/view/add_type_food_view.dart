import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/food/food_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AddTypeFoodView extends GetWidget<FoodController> {
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
              Text('Thêm phân loại', style: StyleThemeData.bold18(height: 0)),
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
                        : Container(
                            width: 150.w,
                            height: 150.h,
                            alignment: Alignment.center,
                            padding: padding(vertical: 32, horizontal: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: appTheme.backgroundContainer,
                            ),
                            child: Text('Chọn ảnh', style: StyleThemeData.regular14()),
                          );
                  },
                ),
                ElevatedButton(
                  onPressed: controller.imageFromGallery,
                  child: Text('Chọn ảnh', style: StyleThemeData.regular14()),
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.nameTypeController,
                  hintText: 'Tên phân loại',
                  label: 'Tên phân loại',
                  suffix: Icon(Icons.title),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.desTypeController,
                  hintText: 'Mô tả phân loại',
                  label: 'Mô tả phân loại',
                  suffix: Icon(Icons.description),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 24.h),
                ConfirmationButtonWidget(
                  isLoading: false,
                  onTap: controller.addTypeFood,
                  text: 'Xác nhận',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
