import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

void showLoading() {
  EasyLoading.show(maskType: EasyLoadingMaskType.black);
}

void showPrinterLoading() {
  EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      indicator: Container(
        color: appTheme.whiteText,
        child: Column(
          children: [
            ImageAssetCustom(imagePath: ImagesAssets.printer, size: 300.w),
            SizedBox(height: 16.h),
            Text('Đang in đơn. Vui lòng đợi trong giây lát',
                style: StyleThemeData.bold16(), textAlign: TextAlign.center),
          ],
        ),
      ));
}

void dissmissLoading() {
  EasyLoading.dismiss();
}

Future<T?> excute<T>(Future<T> Function() function) async {
  try {
    showLoading();
    final result = await function.call();
    return result;
  } catch (e) {
    await DialogUtils.showInfoErrorDialog(content: 'try_again'.tr);
    print(e);
  } finally {
    dissmissLoading();
  }

  return null;
}
