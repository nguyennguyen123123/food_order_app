import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/check_in_out.dart';
import 'package:food_delivery_app/screen/check_in_out/check_in_out_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';

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
      body: Padding(
        padding: padding(bottom: 16),
        child: Column(
          children: [
            Obx(
              () => controller.account.value.role == USER_ROLE.STAFF
                  ? Padding(
                      padding: padding(horizontal: 16),
                      child: Row(
                        children: [
                          Flexible(
                            child: Opacity(
                              opacity: controller.account.value.checkInTime != null ? 0.5 : 1,
                              child: InkWell(
                                onTap: controller.account.value.checkInTime != null ? null : controller.checkInUser,
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
                              opacity: controller.account.value.checkInTime == null ? 0.5 : 1,
                              child: InkWell(
                                onTap: controller.account.value.checkInTime == null ? null : controller.checkOutUser,
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
            Obx(() => (controller.account.value.role == USER_ROLE.STAFF) ? SizedBox(height: 24.h) : SizedBox()),
            Obx(
              () => Expanded(
                child: controller.listCheckInOut.value == null
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: padding(horizontal: 12),
                        child: RefreshIndicator(
                          onRefresh: controller.onRefresh,
                          child: LoadMore(
                            delegate: LoadMoreDelegateCustom(),
                            onLoadMore: controller.onLoadMoreCheckInOut,
                            child: ListView.separated(
                              itemCount: controller.listCheckInOut.value!.length,
                              separatorBuilder: (context, index) => SizedBox(height: 8.h),
                              itemBuilder: (context, index) => itemDataWidget(controller.listCheckInOut.value![index]),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemDataWidget(CheckInOut data) {
    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: appTheme.background,
        border: Border.all(color: appTheme.textDesColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('user'.tr + ': ', style: StyleThemeData.bold18()),
              Text(data.users?.name ?? '', style: StyleThemeData.bold14()),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Check in', style: StyleThemeData.regular16()),
                    SizedBox(height: 8.h),
                    Text(
                      data.checkInTime != null
                          ? DateFormat("yyyy/MM/dd HH:mm").format(DateTime.tryParse(data.checkInTime ?? '')!)
                          : 'Null',
                      style: StyleThemeData.regular14(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Check out', style: StyleThemeData.regular16()),
                    SizedBox(height: 8.h),
                    Text(
                      data.checkOutTime != null
                          ? DateFormat("yyyy/MM/dd HH:mm").format(DateTime.tryParse(data.checkOutTime ?? '')!)
                          : 'Null',
                      style: StyleThemeData.regular14(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: appTheme.blackText),
          Row(
            children: [
              Text('total_order'.tr + ': ', style: StyleThemeData.bold16()),
              Text(data.totalOrders.toString(), style: StyleThemeData.bold14()),
            ],
          ),
        ],
      ),
    );
  }
}
