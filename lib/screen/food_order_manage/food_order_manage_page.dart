import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/food_order_manage/food_order_manage_controller.dart';
import 'package:food_delivery_app/screen/order_detail/view/order_detail_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
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
            Text('Danh sách đơn hàng đang làm'.tr, style: StyleThemeData.bold18(height: 0)),
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
    final isPartyOrder = item.orderType == ORDER_TYPE.PARTY;
    // final partyOrderNormal = item.partyOrders?.firstWhere((value) => value.partyNumber == null);
    final partyOrder = item.partyOrders?.where((value) => value.partyNumber != null).toList() ?? [];
    final numberOfParty = isPartyOrder ? partyOrder.length : 0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.toNamed(Routes.ORDER_DETAIL, arguments: OrderDetailParameter(foodOrder: item, canEdit: true)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('order_person'.tr + (item.userOrder?.name ?? ''), style: StyleThemeData.bold18(height: 0)),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    itemData(title: 'table_number'.tr, data: item.tableNumber ?? ''),
                    SizedBox(height: 4.h),
                    itemData(title: 'price'.tr, data: Utils.getCurrency(item.totalPrice)),
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
          if (isPartyOrder) ...[
            SizedBox(height: 6.h),
            Center(child: Text('Số lượng đơn hàng party: $numberOfParty', style: StyleThemeData.regular16()))
          ]
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
