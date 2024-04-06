import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/staff_manage/staff_manage_controller.dart';
import 'package:food_delivery_app/screen/staff_manage/widget/staff_dialog.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class StaffManagePage extends GetWidget<StaffManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Quản lý nhân viên', style: StyleThemeData.bold18(color: appTheme.whiteText)),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: appTheme.whiteText,
              size: 25.w,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                final result = await DialogUtils.showDialogView(StaffDialog());
                if (result != null) {
                  controller.onAddAccount(result);
                }
              },
              child: Icon(
                Icons.add,
                color: appTheme.whiteText,
                size: 25.w,
              ),
            ),
          ],
          backgroundColor: appTheme.primaryColor),
      body: Column(
        children: [],
      ),
    );
  }
}
