import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class DialogUtils {
  static showDialogView(Widget view) {
    return showDialog(context: Get.context!, useRootNavigator: false, builder: (context) => Dialog(child: view));
  }

  static showBTSView(Widget view) {
    return showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints(maxWidth: double.infinity, maxHeight: Get.height * .75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) => Container(
          height: Get.height * .75,
          constraints: BoxConstraints(maxWidth: double.infinity, maxHeight: Get.height * .75),
          padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          child: Padding(padding: padding(all: 12), child: view)),
    );
  }

  static Future<T?> showYesNoDialog<T>(
      {Function()? onNegative,
      Function()? onPositive,
      String? labelNegative,
      String? labelPositive,
      Color? labelPostiveColor,
      required String title,
      String? description}) async {
    return await showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
              surfaceTintColor: appTheme.whiteText,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: padding(horizontal: 16, top: 16), child: Text(title, style: StyleThemeData.bold16())),
                  if (description != null) ...[
                    SizedBox(height: 16.h),
                    Text(description, style: StyleThemeData.regular16()),
                  ],
                  SizedBox(height: 16.h),
                  Divider(color: appTheme.blackColor.withOpacity(0.1), height: 1.h),
                  Padding(
                    padding: padding(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: PrimaryButton(
                              backgroundColor: appTheme.whiteText,
                              borderColor: appTheme.whiteText,
                              contentPadding: padding(all: 2),
                              onPressed: onNegative ?? () => Get.back(result: false),
                              child: Text(
                                labelNegative ?? "no".tr,
                                style: StyleThemeData.regular17().copyWith(color: appTheme.blackColor),
                              )),
                        ),
                        Container(height: 50.h, width: 1.w, color: appTheme.blackColor.withOpacity(0.1)),
                        Expanded(
                          child: PrimaryButton(
                              backgroundColor: appTheme.whiteText,
                              borderColor: appTheme.whiteText,
                              contentPadding: padding(all: 2),
                              onPressed: onPositive ?? () => Get.back(result: true),
                              child: Text(
                                labelPositive ?? "yes".tr,
                                style:
                                    StyleThemeData.bold17().copyWith(color: labelPostiveColor ?? appTheme.primaryColor),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ));
        });
  }
}
