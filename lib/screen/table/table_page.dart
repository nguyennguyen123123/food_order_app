import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class TablePage extends GetWidget<TableControlller> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.transparentColor,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: padding(horizontal: 16),
            child: Text('table_list'.tr, style: StyleThemeData.bold18(height: 0)),
          ),
        ),
        body: Padding(
          padding: padding(all: 16),
          child: Column(
            children: [
              Obx(
                () => controller.areaTypeList.isNotEmpty
                    ? Align(alignment: Alignment.centerLeft, child: Text('area'.tr, style: StyleThemeData.bold18()))
                    : Container(),
              ),
              SizedBox(height: 8.h),
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.areaTypeList.map((area) {
                        final isSelected = controller.tableList.value?.first.areaId == area.areaId;

                        return Padding(
                          padding: padding(right: 12),
                          child: InkWell(
                            onTap: () => controller.getListAreaTable(area.areaId ?? ''),
                            child: Container(
                              padding: padding(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isSelected ? appTheme.appColor : appTheme.frameColor,
                              ),
                              child: Text(
                                area.areaName ?? '',
                                style: StyleThemeData.bold14(height: 0, color: appTheme.whiteText),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              SizedBox(height: 12.h),
              Align(alignment: Alignment.centerLeft, child: Text('table_number'.tr, style: StyleThemeData.bold18())),
              SizedBox(height: 8.h),
              Obx(() {
                if (controller.tableList.value == null)
                  return Center(child: CircularProgressIndicator());
                else
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.getListTable,
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: controller.tableList.value!.map(itemTableView).toList(),
                      ),
                    ),
                  );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemTableView(TableModels table) {
    return GestureDetector(
      onTap: () => controller.navigateToOrderInTable(table),
      child: Container(
        padding: padding(all: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: appTheme.appColor.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (table.tableNumber ?? 1).toString(),
              style: StyleThemeData.regular16(height: 0),
              textAlign: TextAlign.center,
            ),
            if (table.foodOrder != null)
              Text(
                'order'.tr + ': ${table.foodOrder?.totalPrice.toStringAsFixed(2)}',
                style: StyleThemeData.regular10(),
              )
          ],
        ),
      ),
    );
  }
}
