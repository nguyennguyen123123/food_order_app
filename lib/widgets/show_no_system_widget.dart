import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

void showNoSystemWidget(
  BuildContext context, {
  required String title,
  required String des,
  required String cancel,
  required String confirm,
  required VoidCallback ontap,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Text(
              title,
              style: StyleThemeData.bold18(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              des,
              style: StyleThemeData.regular14(color: appTheme.textDesColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      alignment: Alignment.center,
                      padding: padding(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: appTheme.appColor),
                      ),
                      child: Text(
                        cancel,
                        style: StyleThemeData.bold14(color: appTheme.appColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: InkWell(
                    onTap: ontap,
                    child: Container(
                      alignment: Alignment.center,
                      padding: padding(vertical: 9, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: appTheme.appColor,
                      ),
                      child: Text(
                        confirm,
                        style: StyleThemeData.bold14(color: appTheme.whiteText),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
