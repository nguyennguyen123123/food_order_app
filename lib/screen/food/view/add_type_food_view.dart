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
    return Scaffold(
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
      body: Padding(
        padding: padding(all: 16),
        child: Column(
          children: [
            EditTextFieldCustom(
              controller: controller.nameTypeController,
              hintText: 'Tên phân loại',
              label: 'Tên phân loại',
              suffix: Icon(Icons.title),
              textInputType: TextInputType.text,
            ),
            SizedBox(height: 8),
            EditTextFieldCustom(
              controller: controller.desTypeController,
              hintText: 'Mô tả phân loại',
              label: 'Mô tả phân loại',
              suffix: Icon(Icons.description),
              textInputType: TextInputType.text,
            ),
            SizedBox(height: 24),
            ConfirmationButtonWidget(
              isLoading: false,
              onTap: controller.addTypeFood,
              text: 'Xác nhận',
            ),
          ],
        ),
      ),
    );
  }
}
