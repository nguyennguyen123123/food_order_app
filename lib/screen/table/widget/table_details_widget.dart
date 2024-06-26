import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class TableDetailsWidget extends StatelessWidget {
  const TableDetailsWidget({
    Key? key,
    required this.table,
    required this.onTapDelete,
    required this.onTapEdit,
  }) : super(key: key);

  final TableModels table;
  final VoidCallback onTapDelete;
  final VoidCallback onTapEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: padding(all: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text('table_info'.tr, style: StyleThemeData.bold16())),
            SizedBox(height: 12.h),
            Row(
              children: [
                Text('table_number'.tr + ': ', style: StyleThemeData.bold18()),
                Text(table.tableNumber.toString(), style: StyleThemeData.regular16()),
              ],
            ),
            SizedBox(height: 24.h),
            if (table.foodOrder != null)
              Row(
                children: [
                  Text('order'.tr + ': ', style: StyleThemeData.bold18()),
                  Text(table.foodOrder?.totalPrice.toStringAsFixed(2) ?? '', style: StyleThemeData.regular16()),
                ],
              )
            else
              Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: onTapDelete,
                      child: Container(
                        width: Get.size.width.w,
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.errorColor),
                        ),
                        child: Text('delete'.tr, style: StyleThemeData.bold18(height: 0, color: appTheme.errorColor)),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    child: InkWell(
                      onTap: onTapEdit,
                      child: Container(
                        width: Get.size.width.w,
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.appColor,
                        ),
                        child: Text('edit'.tr, style: StyleThemeData.bold18(height: 0, color: appTheme.whiteText)),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
