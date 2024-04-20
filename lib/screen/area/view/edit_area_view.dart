import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/area/edit/edit_table_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/number_formatter.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class EditAreaView extends GetWidget<EditAreaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: appTheme.blackText)),
            Text('edit_area'.tr, style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Column(
          children: [
            EditTextFieldCustom(
              controller: controller.areaNameController,
              hintText: 'enter_name_area'.tr,
              label: 'area'.tr,
              suffix: Icon(Icons.title),
              textInputType: TextInputType.number,
              numberFormat: NumericTextFormatter(),
            ),
            SizedBox(height: 24.h),
            Obx(
              () => ConfirmationButtonWidget(
                isLoading: controller.isLoading.isTrue,
                onTap: controller.editArea,
                text: 'edit'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
