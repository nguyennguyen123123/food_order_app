import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/food_order_manage/food_order_manage_controller.dart';
import 'package:food_delivery_app/screen/order_detail/order_detail_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/list_vertical_item.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';

class FoodOrderManagePage extends GetWidget<FoodOrderManageController> {
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
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: appTheme.blackColor)),
            Text('order_list'.tr, style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Obx(
          () => LoadMore(
            onLoadMore: controller.onLoadMore,
            child: controller.foodOrderList.value == null
                ? Center(child: CircularProgressIndicator())
                : ListVerticalItem<FoodOrder>(
                    lineItemCount: 1,
                    items: controller.foodOrderList.value!,
                    divider: Padding(
                      padding: padding(vertical: 8),
                      child: Divider(height: 1.h),
                    ),
                    itemBuilder: _buildFoodOrderItem,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodOrderItem(int index, FoodOrder item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.toNamed(Routes.ORDER_DETAIL, arguments: OrderDetailParameter(foodOrder: item)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('order_person'.tr + (item.userOrder?.name ?? ''), style: StyleThemeData.bold18(height: 0)),
          SizedBox(height: 8.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.orderItems?.first.food?.image ?? '',
                  fit: BoxFit.cover,
                  width: 80.w,
                  height: 80.w,
                  errorWidget: (context, url, error) {
                    return Image.asset(ImagesAssets.noUrlImage);
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    itemData(title: 'food'.tr, data: item.orderItems?.first.food?.name ?? ''),
                    SizedBox(height: 8.h),
                    itemData(title: 'table_number'.tr, data: item.tableNumber ?? ''),
                    SizedBox(height: 4.h),
                    itemData(title: 'price'.tr, data: Utils.getCurrency(item.total?.toInt())),
                    SizedBox(height: 4.h),
                    itemData(
                        title: 'time'.tr,
                        data: DateFormat("yyyy/MM/dd HH:mm")
                            .format(DateTime.tryParse(item.createdAt ?? '') ?? DateTime.now())),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemData({required String title, required String data}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title :', style: StyleThemeData.bold18(height: 0)),
        SizedBox(width: 4.w),
        Expanded(child: Text(data, style: StyleThemeData.bold14(height: 0))),
      ],
    );
  }
}