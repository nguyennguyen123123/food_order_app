import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/screen/order_detail/order_detail_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends GetWidget<OrderDetailController> {
  @override
  Widget build(BuildContext context) {
    final order = controller.parameter.foodOrder;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: appTheme.blackColor)),
            Text('detail_order'.tr, style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: ListView(
        padding: padding(all: 12),
        children: [
          itemData(title: 'order_id'.tr, data: order.orderId ?? ''),
          SizedBox(height: 4.h),
          itemData(title: 'table_number'.tr, data: order.tableNumber ?? ''),
          SizedBox(height: 4.h),
          itemData(title: 'total'.tr, data: Utils.getCurrency(order.total?.toInt())),
          SizedBox(height: 4.h),
          itemData(
              title: 'time'.tr,
              data: DateFormat("yyyy/MM/dd HH:mm").format(DateTime.tryParse(order.createdAt ?? '') ?? DateTime.now())),
          SizedBox(height: 8.h),
          ...?order.orderItems?.map(_buildOrderItem)
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: padding(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.food?.image ?? '',
              fit: BoxFit.cover,
              width: 120.w,
              height: 120.w,
              errorWidget: (context, url, error) {
                return Image.asset(ImagesAssets.noUrlImage);
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
              child: Column(
            children: [
              itemData(title: 'food'.tr, data: item.food?.name ?? ''),
              SizedBox(height: 8.h),
              itemData(title: 'quantity'.tr, data: (item.quantity ?? 1).toString()),
              SizedBox(height: 4.h),
              itemData(title: 'total'.tr, data: Utils.getCurrency((item.quantity ?? 1) * (item.food?.price ?? 0))),
            ],
          ))
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