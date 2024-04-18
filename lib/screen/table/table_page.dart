import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:food_delivery_app/screen/table/table_parameter.dart';
import 'package:food_delivery_app/screen/table/widget/table_details_widget.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class TablePage extends GetWidget<TableControlller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        // title: Row(
        //   children: [
        //     IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: appTheme.blackText)),
        //     Text('table_list'.tr, style: StyleThemeData.bold18(height: 0)),
        //   ],
        // ),
        title: Padding(
          padding: padding(horizontal: 16),
          child: Text('table_list'.tr, style: StyleThemeData.bold18(height: 0)),
        ),
        actions: [
          IconButton(onPressed: () => Get.toNamed(Routes.ADDTABLE), icon: Icon(Icons.add)),
          SizedBox(width: 12.w),
        ],
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Obx(
          () => Column(
            children: [
              if (controller.tableList.isEmpty)
                Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: controller.tableList.map((table) {
                      return itemTableView(
                        table.numberOfOrder.toString(),
                        onTap: () => showModalBottomSheet(
                          context: Get.context!,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          builder: (context) => TableDetailsWidget(
                            table: table,
                            onTapDelete: () => controller.deleteTable(table.tableId.toString()),
                            onTapEdit: () {
                              Get.back();
                              Get.toNamed(Routes.EDITTABLE, arguments: TableParameter(tableModels: table));
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemTableView(String data, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding(all: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: appTheme.appColor.withOpacity(0.5),
        ),
        child: Text(data, style: StyleThemeData.regular16(height: 0), textAlign: TextAlign.center),
      ),
    );
  }
}
