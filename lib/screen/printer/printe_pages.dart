import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/printer/printer_controller.dart';
import 'package:food_delivery_app/screen/printer/printer_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class PrinterPages extends GetWidget<PrinterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        title: Text('Quản lý máy in', style: StyleThemeData.bold18(height: 0)),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.ADDPRINTER);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Obx(
          () => ListView.separated(
            itemCount: controller.printer.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final printer = controller.printer[index];

              return itemPrinterWidget(printer);
            },
          ),
        ),
      ),
    );
  }

  Container itemPrinterWidget(Printer printer) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: appTheme.whiteText,
      ),
      child: Padding(
        padding: padding(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            itemData(title: 'Ip', data: printer.ip.toString()),
            SizedBox(height: 8.h),
            itemData(title: 'Tên', data: printer.name.toString()),
            SizedBox(height: 8.h),
            itemData(title: 'Port', data: printer.port.toString()),
            SizedBox(height: 8.h),
            Obx(
              () => Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: controller.isLoadingDelete.isTrue
                          ? null
                          : () => controller.deletePrinter(printer.id.toString()),
                      child: Container(
                        width: Get.size.width.w,
                        height: 32.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.errorColor),
                        ),
                        child: controller.isLoadingDelete.isTrue
                            ? Container(width: 16.w, height: 16.h, child: CircularProgressIndicator())
                            : Text(
                                'Xóa', 
                                style: StyleThemeData.bold14(color: appTheme.errorColor, height: 0),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Flexible(
                    child: InkWell(
                      onTap: () => Get.toNamed(Routes.EDITPRINTER, arguments: PrinterParameter(printer: printer)),
                      child: Container(
                        width: Get.size.width.w,
                        height: 32.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.appColor,
                        ),
                        child: Text(
                          'edit'.tr,
                          style: StyleThemeData.bold14(color: appTheme.whiteText, height: 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row itemData({required String title, required String data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: StyleThemeData.bold14()),
        Text(data, style: StyleThemeData.bold14(color: appTheme.textInputColor)),
      ],
    );
  }
}
