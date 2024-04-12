import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/voucher/edit/edit_voucher_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:get/get.dart';

class EditVoucherView extends GetWidget<EditVoucherController> {
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
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
            Text('Edit Voucher', style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
    );
  }
}
