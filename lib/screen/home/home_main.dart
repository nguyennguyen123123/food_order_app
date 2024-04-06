import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/home/main_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/icons_assets.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeMain extends StatelessWidget {
  final MainController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _mainController.pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: _mainController.animateToTab,
              children: [..._mainController.pages],
            ),
          ),
          Container(
            padding: padding(left: 16, right: 16, top: 12, bottom: 8),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: appTheme.borderColor))),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomAppBarItem(context, icon: IconAssets.homeIcon, page: 0, label: 'Trang chủ'),
                  _bottomAppBarItem(context, icon: IconAssets.settingsIcon, page: 1, label: 'Hồ sơ'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required String icon,
    required int page,
    required String label,
    Widget? avatar,
  }) {
    return ZoomTapAnimation(
      onTap: () => _mainController.goToTab(page),
      child: Container(
        color: appTheme.transparentColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            avatar ??
                SvgPicture.asset(
                  icon,
                  color: _mainController.currentPage == page ? appTheme.appColor : appTheme.textDesColor,
                ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: StyleThemeData.bold10(
                color: _mainController.currentPage == page ? appTheme.appColor : appTheme.textDesColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
