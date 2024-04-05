import 'package:flutter/material.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/admin/admin_controller.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:get/get.dart';

class AdminPage extends GetWidget<AdminController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConfirmationButtonWidget(onTap: () => Get.toNamed(Routes.STAFF_MANAGE), text: "Tạo nhân viên"),
        ],
      ),
    );
  }
}
