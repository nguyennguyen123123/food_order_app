import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: ImageAssetCustom(imagePath: ImagesAssets.emptyCart, size: 200)),
        SizedBox(height: 12.h),
        PrimaryButton(
          contentPadding: padding(all: 12),
          backgroundColor: appTheme.primaryColor,
          borderColor: appTheme.primaryColor,
          onPressed: Get.back,
          child: Text(
            'select_food'.tr,
            style: StyleThemeData.regular14(color: appTheme.whiteText),
          ),
        ),
      ],
    );
  }
}
