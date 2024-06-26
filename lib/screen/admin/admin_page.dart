import 'package:flutter/material.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/admin/admin_controller.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AdminPage extends GetWidget<AdminController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConfirmationButtonWidget(onTap: () => Get.toNamed(Routes.FOOD), text: "create_food".tr),
          SizedBox(height: 24.h),
          ConfirmationButtonWidget(onTap: () => Get.toNamed(Routes.STAFF_MANAGE), text: "create_staff".tr),
          SizedBox(height: 24.h),
          ConfirmationButtonWidget(onTap: () => Get.toNamed(Routes.TABLEMANAGE), text: 'table_manage'.tr),
          SizedBox(height: 24.h),
          ConfirmationButtonWidget(onTap: () => Get.toNamed(Routes.AREA), text: 'area'.tr),
          SizedBox(height: 24.h),
          ConfirmationButtonWidget(onTap: () => Get.toNamed(Routes.PRINT), text: 'printer_management'.tr),
          SizedBox(height: 24.h),
          ConfirmationButtonWidget(onTap: () => Get.toNamed(Routes.VOUCHER), text: 'voucher'.tr),
        ],
      ),
    );
  }
}
