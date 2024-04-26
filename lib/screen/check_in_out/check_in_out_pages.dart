import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/check_in_out.dart';
import 'package:food_delivery_app/screen/check_in_out/check_in_out_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
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
        actions: controller.accountService.isAdmin
            ? [
                GestureDetector(
                  onTap: controller.onDeleteOrder,
                  child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30),
                ),
                SizedBox(width: 12.w)
              ]
            : [],
      ),
      body: Padding(
        padding: padding(bottom: 16),
        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: padding(horizontal: 16, bottom: 24),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Flexible(
                        child: Opacity(
                          opacity: controller.account?.checkInTime != null ? 0.5 : 1,
                          child: InkWell(
                            onTap: controller.account?.checkInTime != null ? null : controller.checkInUser,
                            child: Container(
                              width: Get.size.width.w,
                              padding: padding(vertical: 12),
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
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Check In',
                                            style: StyleThemeData.bold18(height: 0, color: appTheme.appColor)),
                                        if (controller.account?.checkInTime != null) ...[
                                          SizedBox(height: 5.h),
                                          Text(DateFormat(PRINTER_DAY_FORMAT).format(
                                              DateTime.tryParse(controller.account?.checkInTime ?? '') ??
                                                  DateTime.now()))
                                        ]
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Flexible(
                        child: Opacity(
                          opacity: controller.account?.checkInTime == null ? 0.5 : 1,
                          child: InkWell(
                            onTap: controller.account?.checkInTime == null ? null : controller.checkOutUser,
                            child: Container(
                              width: Get.size.width.w,
                              padding: padding(vertical: 12),
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
                ),
              ),
            ),
            if (controller.accountService.isAdmin) ...[
              TabBar(
                tabs: controller.tab,
                controller: controller.tabCtr,
                onTap: (value) => controller.onChangeTab(value),
              ),
              SizedBox(height: 12)
            ],
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
    return Row(
      children: [
        Obx(() {
          if (controller.currentTab.value == 1) {
            final isSelected = controller.selectedCheckinCheckout.value.contains(data.id);
            return Checkbox(
                value: isSelected,
                onChanged: (value) => controller.onUpdateCurrentOrderSelect(value ?? false, data.id ?? 0));
          }
          return SizedBox();
        }),
        Expanded(
          child: Container(
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
                                : '',
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
                                : '',
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
                    Text('total_profit'.tr + ': ', style: StyleThemeData.bold16()),
                    Text(Utils.getCurrency(data.totalPrice), style: StyleThemeData.bold14()),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text('total_order'.tr + ': ', style: StyleThemeData.bold16()),
                    Text(data.totalOrders.toString(), style: StyleThemeData.bold14()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
