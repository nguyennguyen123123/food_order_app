import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/l10n/l10n.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/profile/profile_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/icons_assets.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class ProfileScreen extends GetWidget<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.appColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 110,
        title: Padding(
          padding: padding(horizontal: 16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: CachedNetworkImage(
                  imageUrl: '',
                  width: 65.w,
                  height: 65.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: StyleThemeData.regular16(color: appTheme.whiteText),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Admin',
                    style: StyleThemeData.regular14(color: appTheme.whiteText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Column(
          children: [
            Container(
              padding: padding(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: appTheme.whiteText,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.my_account_text,
                    style: StyleThemeData.bold14(),
                  ),
                  SizedBox(height: 8.h),
                  newMethod(
                    onTap: () {},
                    text: context.l10n.account_text,
                    icons: IconAssets.editIcon,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: padding(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: appTheme.whiteText,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.general_management_text,
                    style: StyleThemeData.regular16(),
                  ),
                  SizedBox(height: 8.h),
                  newMethod(onTap: () {}, text: context.l10n.settings_text, icons: IconAssets.settingsIcon),
                  const Divider(thickness: 1),
                  newMethod(
                    onTap: () {},
                    text: context.l10n.language_text,
                    lable: context.l10n.vietnamese_text,
                    icons: IconAssets.languageIcon,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: padding(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: appTheme.whiteText,
              ),
              child: newMethod(
                onTap: () {
                  Get.snackbar('Đã đăng xuất', 'Bạn đã đăng xuất thành công');
                },
                text: 'Đăng xuất',
                color: appTheme.errorColor,
                icons: IconAssets.logoutIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newMethod({
    required VoidCallback onTap,
    required String text,
    required String icons,
    String lable = '',
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding(vertical: 8),
        child: Row(
          children: [
            SvgPicture.asset(icons, color: color ?? appTheme.colorLightmodeNeutral40),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: StyleThemeData.regular14(color: color, height: 0),
                ),
                if (lable.isNotEmpty)
                  Text(
                    lable,
                    style: StyleThemeData.regular12(color: color ?? appTheme.textDesColor),
                  ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset(IconAssets.caretRightIcon, color: color ?? appTheme.colorLightmodeNeutral40),
          ],
        ),
      ),
    );
  }
}
