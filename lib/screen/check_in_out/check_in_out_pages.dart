import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/check_in_out/check_in_out_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class CheckInOutPages extends GetWidget<CheckInOutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: appTheme.blackText)),
            Text('Checking', style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: Column(
        children: [
          Obx(
            () => controller.myAccount?.role == USER_ROLE.STAFF
                ? Padding(
                    padding: padding(horizontal: 16),
                    child: Row(
                      children: [
                        Flexible(
                          child: Opacity(
                            opacity: controller.myAccount?.checkInTime != null ? 0.5 : 1,
                            child: InkWell(
                              onTap: controller.myAccount?.checkInTime != null ? null : controller.checkInUser,
                              child: Container(
                                width: Get.size.width.w,
                                height: 40.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: appTheme.whiteText,
                                  border: Border.all(color: appTheme.appColor),
                                ),
                                child: controller.isLoadingCheckIn.isTrue
                                    ? Container(
                                        width: 20.w,
                                        height: 20.h,
                                        child: CircularProgressIndicator(color: appTheme.appColor),
                                      )
                                    : Text('Check In',
                                        style: StyleThemeData.bold18(height: 0, color: appTheme.appColor)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Flexible(
                          child: Opacity(
                            opacity: controller.myAccount?.checkInTime == null ? 0.5 : 1,
                            child: InkWell(
                              onTap: controller.myAccount?.checkInTime == null ? null : controller.checkOutUser,
                              child: Container(
                                width: Get.size.width.w,
                                height: 40.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: appTheme.appColor,
                                  border: Border.all(color: appTheme.appColor),
                                ),
                                child: controller.isLoadingCheckOut.isTrue
                                    ? Container(
                                        width: 20.w,
                                        height: 20.h,
                                        child: CircularProgressIndicator(color: appTheme.whiteText),
                                      )
                                    : Text('Check Out',
                                        style: StyleThemeData.bold18(height: 0, color: appTheme.whiteText)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => Column(
              children: controller.listCheckInOut.map((data) {
                return Column(
                  children: [
                    Text(data.checkInTime.toString(), style: StyleThemeData.bold16()),
                    Text(data.checkOutTime.toString(), style: StyleThemeData.bold16()),
                    Text(data.totalOrders.toString(), style: StyleThemeData.bold16()),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
