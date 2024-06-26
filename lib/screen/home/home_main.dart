import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/home/main_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/icons_assets.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeMain extends GetWidget<MainController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: controller.animateToTab,
              children: [...controller.pages],
            ),
          ),
          Container(
            padding: padding(left: 16, right: 16, top: 12, bottom: 8),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: appTheme.borderColor))),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // _bottomAppBarItem(context, icon: IconAssets.homeIcon, page: 0, label: 'Trang chủ'),
                  // _bottomAppBarItem(
                  //   context,
                  //   icon: IconAssets.shoppingCartIcon,
                  //   page: 1,
                  //   label: 'Giỏ hàng',
                  //   widget: (controller.cartService.items.value.isNotEmpty)
                  //       ? Positioned(
                  //           top: -12,
                  //           right: -10,
                  //           child: Container(
                  //             padding: padding(all: 4),
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: appTheme.errorColor,
                  //             ),
                  //             child: Text(
                  //               controller.cartService.items.value.length.toString(),
                  //               style: StyleThemeData.regular14(height: 0, color: appTheme.whiteText),
                  //             ),
                  //           ),
                  //         )
                  //       : null,
                  // ),
                  _bottomAppBarItem(context, icon: IconAssets.cancelIcon, page: 0, label: 'table'.tr),
                  _bottomAppBarItem(context, icon: IconAssets.settingsIcon, page: 1, label: 'profile_text'.tr),
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
    Widget? widget,
  }) {
    return ZoomTapAnimation(
      onTap: () => controller.goToTab(page),
      child: Container(
        color: appTheme.transparentColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                avatar ??
                    SvgPicture.asset(
                      icon,
                      color: controller.currentPage == page ? appTheme.appColor : appTheme.textDesColor,
                      width: 24.w,
                    ),
                widget ?? Container(),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: StyleThemeData.bold10(
                color: controller.currentPage == page ? appTheme.appColor : appTheme.textDesColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
