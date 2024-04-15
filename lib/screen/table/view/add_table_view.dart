import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/number_formatter.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AddTableView extends GetWidget<TableControlller> {
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
            Text('add_nre_table'.tr, style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Column(
          children: [
            EditTextFieldCustom(
              controller: controller.tableNumberController,
              hintText: 'enter_table_number'.tr,
              label: 'table_number'.tr,
              suffix: Icon(Icons.title),
              textInputType: TextInputType.number,
              numberFormat: NumericTextFormatter(),
            ),
            SizedBox(height: 12.h),
            EditTextFieldCustom(
              controller: controller.numberOfOrderController,
              hintText: 'enter_order_number'.tr,
              label: 'order_number'.tr,
              suffix: Icon(Icons.description),
              textInputType: TextInputType.number,
              numberFormat: NumericTextFormatter(),
            ),
            SizedBox(height: 12.h),
            EditTextFieldCustom(
              controller: controller.numberOfPeopleController,
              hintText: 'enter_number_of_guests'.tr,
              label: 'number_of_guests'.tr,
              suffix: Icon(Icons.price_change),
              textInputType: TextInputType.number,
              numberFormat: NumericTextFormatter(),
            ),
            SizedBox(height: 24.h),
            Obx(
              () => ConfirmationButtonWidget(
                isLoading: controller.isLoadingAdd.isTrue,
                onTap: controller.addTable,
                text: 'confirm'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
