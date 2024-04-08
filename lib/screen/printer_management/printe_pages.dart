import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/printer_management/printer_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class PrinterPages extends GetWidget<PrinterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        title: Text('Quản lý máy in', style: StyleThemeData.bold18(height: 0)),
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                controller.addPrinter();
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
