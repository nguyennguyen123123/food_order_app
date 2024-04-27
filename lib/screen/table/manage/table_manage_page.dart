import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/table/manage/table_manage_controller.dart';
import 'package:food_delivery_app/screen/table/table_parameter.dart';
import 'package:food_delivery_app/screen/table/widget/table_details_widget.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/load_more_list_vertical_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class TableManagePage extends GetWidget<TableManageControlller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
            Text('table_list'.tr, style: StyleThemeData.bold18(height: 0)),
          ],
        ),
        actions: [
          IconButton(onPressed: () => Get.toNamed(Routes.ADDTABLE), icon: Icon(Icons.add)),
          SizedBox(width: 12.w),
        ],
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Obx(() {
          if (controller.tableList.value == null)
            return Center(child: CircularProgressIndicator());
          else
            return RefreshIndicator(
              onRefresh: controller.getListTable,
              child: LoadMoreListVerticalItem<TableModels>(
                lineItemCount: 3,
                viewPadding: padding(),
                divider: SizedBox(height: 8.h),
                items: controller.tableList.value!,
                loadMore: controller.onLoadMoreTable,
                itemBuilder: (index, item) => itemTableView(item),
              ),
            );
        }),
      ),
    );
  }

  Widget itemTableView(TableModels table) {
    return GestureDetector(
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
            // if (table.foodOrder != null)
            //   Text(
            //     'order'.tr + ': ${table.foodOrder?.totalPrice.toStringAsFixed(2)}',
            //     style: StyleThemeData.regular10(),
            //   )
          ],
        ),
      ),
    );
  }
}
