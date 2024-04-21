import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class ListAreaTable extends GetWidget<TableControlller> {
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
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: appTheme.blackText)),
            Text('Số bàn', style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Obx(() {
          if (controller.listAreaTable.isEmpty)
            return Center(
              child: Container(
                child: Text('Khu vực này chưa có bàn nào', style: StyleThemeData.bold18(height: 0)),
              ),
            );
          else
            return Expanded(
              child: RefreshIndicator(
                onRefresh: controller.getListTable,
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: controller.listAreaTable.map(itemTableView).toList(),
                ),
              ),
            );
        }),
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
              Text('Đơn hàng: ${table.foodOrder?.totalPrice.toStringAsFixed(2)}', style: StyleThemeData.regular10())
          ],
        ),
      ),
    );
  }
}
