import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/constant/translations/localization_service.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/profile/profile_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/icons_assets.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/show_no_system_widget.dart';
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
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.account.value.name.toString(),
                      style: StyleThemeData.regular16(color: appTheme.whiteText),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      controller.account.value.role.toString(),
                      style: StyleThemeData.regular14(color: appTheme.whiteText),
                    ),
                  ],
                ),
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
                    'my_account'.tr,
                    style: StyleThemeData.bold14(),
                  ),
                  SizedBox(height: 8.h),
                  newMethod(
                    onTap: () => Get.toNamed(Routes.MYACCOUNT),
                    text: 'account'.tr,
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
                    'general_management'.tr,
                    style: StyleThemeData.regular16(),
                  ),
                  SizedBox(height: 8.h),
                  newMethod(
                    onTap: () => Get.toNamed(Routes.MANAGE_ORDER),
                    text: "order_management".tr,
                    icons: IconAssets.cancelIcon,
                  ),
                  const Divider(thickness: 1),
                  newMethod(onTap: () => Get.toNamed(Routes.ADMIN), text: "Admin", icons: IconAssets.adminIcon),
                  const Divider(thickness: 1),
                  newMethod(
                    onTap: () {
                      Get.toNamed(Routes.LANGUAGE);
                    },
                    text: 'language'.tr,
                    lable: LocalizationService.locale.languageCode == 'en' ? 'english'.tr : 'vietnamese'.tr,
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
                  showNoSystemWidget(
                    context,
                    title: 'confirm_logout'.tr,
                    des: 'you_definitely_want_to_sign_out'.tr,
                    cancel: 'cancel'.tr,
                    confirm: 'confirm'.tr,
                    ontap: () {
                      Get.back();
                      controller.signOut().then(
                            (value) => Get.snackbar('signed_out'.tr, 'you_have_successfully_logged_out'.tr),
                          );
                    },
                  );
                },
                text: 'log_out'.tr,
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
            SvgPicture.asset(icons, width: 20.w, color: color ?? appTheme.colorLightmodeNeutral40),
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
