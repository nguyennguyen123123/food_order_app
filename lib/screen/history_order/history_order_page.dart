import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/history_order/history_order_controller.dart';
import 'package:food_delivery_app/screen/order_detail/view/order_detail_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';

class HistoryOrderPage extends GetWidget<HistoryOrderController> {
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
        padding: padding(all: 16),
        child: Obx(
          () => Column(
            children: [
              TabBar(
                tabs: controller.tab,
                controller: controller.tabCtr,
                onTap: (value) => controller.onChangeTab(value),
              ),
              Expanded(
                child: LoadMore(
                  onLoadMore: controller.onLoadMore,
                  delegate: LoadMoreDelegateCustom(),
                  child: controller.foodOrderList.value == null
                      ? Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          itemCount: controller.foodOrderList.value!.length,
                          separatorBuilder: (context, index) => Padding(
                            padding: padding(vertical: 8),
                            child: Divider(height: 1.h),
                          ),
                          itemBuilder: (context, index) =>
                              _buildFoodOrderItem(index, controller.foodOrderList.value![index]),
                        ),
                ),
              ),
            ],
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
      onTap: () => Get.toNamed(Routes.ORDER_DETAIL, arguments: OrderDetailParameter(foodOrder: item)),
      child: Row(
        children: [
          Obx(() {
            if (controller.currentTab.value == 1) {
              final isSelected = controller.orderSelecteIds.value.contains(item.orderId);
              return Checkbox(
                  value: isSelected,
                  onChanged: (value) => controller.onUpdateCurrentOrderSelect(value ?? false, item.orderId ?? ''));
            }
            return SizedBox();
          }),
          Expanded(
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
