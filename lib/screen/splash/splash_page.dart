import 'package:flutter/material.dart';
import 'package:food_delivery_app/screen/splash/splash_controller.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:get/get.dart';

class SplashPage extends GetWidget<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: ImageAssetCustom(imagePath: ImagesAssets.appIcon, size: 100))],
      ),
    );
  }
}
