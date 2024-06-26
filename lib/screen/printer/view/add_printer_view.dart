import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/printer/printer_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AddPrinterView extends GetWidget<PrinterController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.transparentColor,
          title: Text('add_printer'.tr, style: StyleThemeData.bold18(height: 0)),
        ),
        body: Padding(
          padding: padding(all: 16),
          child: Column(
            children: [
              EditTextFieldCustom(
                controller: controller.ipController,
                hintText: 'enter_ip'.tr,
                label: 'IP',
                suffix: Icon(Icons.title),
                textInputType: TextInputType.number,
              ),
              SizedBox(height: 12.h),
              EditTextFieldCustom(
                controller: controller.nameControler,
                hintText: 'enter_name'.tr,
                label: 'name'.tr,
                suffix: Icon(Icons.description),
                textInputType: TextInputType.text,
              ),
              SizedBox(height: 12.h),
              EditTextFieldCustom(
                controller: controller.portController,
                hintText: 'enter_port'.tr,
                label: 'Port',
                suffix: Icon(Icons.price_change),
                textInputType: TextInputType.number,
              ),
              SizedBox(height: 24.h),
              Obx(
                () => ConfirmationButtonWidget(
                  isLoading: controller.isLoadingAdd.isTrue,
                  onTap: controller.addPrinter,
                  text: 'confirm'.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
