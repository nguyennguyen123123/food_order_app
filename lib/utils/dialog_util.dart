import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class DialogUtils {
  static showDialogView(Widget view) {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      builder: (context) => Dialog(
        backgroundColor: appTheme.whiteText,
        child: view,
      ),
    );
  }

  static showBTSView(Widget view, {bool isWrap = false}) {
    return showModalBottomSheet(
      context: Get.context!,
      constraints: !isWrap ? BoxConstraints(maxWidth: double.infinity, maxHeight: Get.height * .75) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) {
        final isKeyboardShow = MediaQuery.of(Get.context!).viewInsets.bottom > 0;
        if (isWrap) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
            child: Wrap(
              children: [view],
            ),
          );
        }
        return Container(
          height: !isWrap ? Get.height * (.75 + (isKeyboardShow ? .15 : 0)) : null,
          constraints: !isWrap
              ? BoxConstraints(maxWidth: double.infinity, maxHeight: Get.height * (.75 + (isKeyboardShow ? .15 : 0)))
              : null,
          padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          child: Padding(padding: padding(all: 12), child: view),
        );
      },
    );
  }

  static Future<T?> showYesNoDialog<T>({
    Function()? onNegative,
    Function()? onPositive,
    String? labelNegative,
    String? labelPositive,
    Color? labelPostiveColor,
    required String title,
    String? description,
  }) async {
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
                  padding: padding(horizontal: 16, top: 16),
                  child: Text(title, textAlign: TextAlign.center, style: StyleThemeData.bold16())),
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
                        ),
                      ),
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
                          style: StyleThemeData.bold17().copyWith(color: labelPostiveColor ?? appTheme.primaryColor),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static showSuccessDialog({
    String content = '',
    TextStyle? contentStyle,
    EdgeInsets? contentPadding,
    String? primaryText,
    String? outlineText,
    bool? barrierDismissible,
  }) {
    return showInfoErrorDialog(
      title: "congrate".tr,
      content: content,
      contentStyle: contentStyle,
      contentPadding: contentPadding,
      primaryText: primaryText,
      outlineText: outlineText,
      barrierDismissible: barrierDismissible,
    );
  }

  static showInfoErrorDialog({
    String content = '',
    String? title,
    TextStyle? contentStyle,
    EdgeInsets? contentPadding,
    String? primaryText,
    String? outlineText,
    bool? barrierDismissible,
  }) async {
    return showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible ?? false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: WillPopScope(
            onWillPop: () async => false,
            child: Container(
              width: 305.w,
              decoration: BoxDecoration(
                color: appTheme.whiteText,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: padding(top: 16, right: 19),
                    child: GestureDetector(onTap: Get.back, child: Icon(Icons.close, size: 24)),
                  ),
                  SizedBox(
                    width: 305.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 32.h),
                        Padding(
                          padding: padding(horizontal: 12),
                          child: Text(title ?? "apologize".tr,
                              style: StyleThemeData.bold24(), textAlign: TextAlign.center),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: contentPadding ?? padding(horizontal: 24),
                          child: Text(
                            content,
                            textAlign: TextAlign.center,
                            style: contentStyle ?? StyleThemeData.regular16(),
                          ),
                        ),
                        SizedBox(height: 36.h)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future showWaitingDialog({
    String imageWaiting = '',
    String description = '',
    double? imageSize,
  }) async {
    return await showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          surfaceTintColor: appTheme.whiteText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: padding(all: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageAssetCustom(imagePath: imageWaiting, size: imageSize ?? 300.w),
                SizedBox(height: 16.h),
                Text(description, style: StyleThemeData.bold16(), textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}
