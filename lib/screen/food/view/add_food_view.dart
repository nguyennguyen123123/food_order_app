import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/screen/food/food_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AddFoodView extends GetWidget<FoodController> {
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
              Text('Thêm món', style: StyleThemeData.bold18(height: 0)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: padding(all: 16),
            child: Column(
              children: [
                
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.nameController,
                  hintText: 'Tên món ăn',
                  label: 'Tên món ăn',
                  suffix: Icon(Icons.title),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.desController,
                  hintText: 'Mô tả món ăn',
                  label: 'Mô tả món ăn',
                  suffix: Icon(Icons.description),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 8.h),
                EditTextFieldCustom(
                  controller: controller.priceController,
                  hintText: 'Giá món ăn',
                  label: 'Giá món ăn',
                  suffix: Icon(Icons.price_change),
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 8.h),
                Align(alignment: Alignment.centerLeft, child: Text('Phân loại', style: StyleThemeData.bold14())),
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
                        hint: Text('Chọn phân loại', style: StyleThemeData.regular16()),
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
                ConfirmationButtonWidget(
                  isLoading: false,
                  onTap: controller.onSubmit,
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
