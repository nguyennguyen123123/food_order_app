import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/screen/order_detail/bottom_sheet/order_add_food_bts.dart';
import 'package:food_delivery_app/screen/order_detail/order_detail_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends GetWidget<OrderDetailController> {
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
            IconButton(onPressed: Get.back, icon: Icon(Icons.arrow_back, color: appTheme.blackColor)),
            Expanded(child: Text('detail_order'.tr, style: StyleThemeData.bold18(height: 0))),
            GestureDetector(
                onTap: () async {
                  final result = await DialogUtils.showYesNoDialog(title: 'Bạn muốn xóa đơn này không?');
                  if (result == true) {
                    controller.onDeleteOrder();
                  }
                },
                child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30)),
          ],
        ),
      ),
      body: Obx(() {
        final order = controller.foodOrder.value;
        return ListView(
          padding: padding(all: 12),
          children: [
            itemData(title: 'order_id'.tr, data: order.orderId ?? ''),
            SizedBox(height: 4.h),
            itemData(title: 'table_number'.tr, data: order.tableNumber ?? ''),
            SizedBox(height: 4.h),
            itemData(
                title: 'time'.tr,
                data:
                    DateFormat("yyyy/MM/dd HH:mm").format(DateTime.tryParse(order.createdAt ?? '') ?? DateTime.now())),
            SizedBox(height: 8.h),
            ...?order.partyOrders?.asMap().entries.map((e) => _buildPartyOrder(e.key, e.value))
          ],
        );
      }),
    );
  }

  Widget _buildPartyOrder(int partyIndex, PartyOrder partyOrder) {
    final number = partyOrder.partyNumber;
    late double total;
    if (controller.parameter.canEdit) {
      total = partyOrder.totalPrice;
    } else {
      total = partyOrder.priceInVoucher;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number != null) ...[
          Row(
            children: [
              Expanded(child: Text('party number: $number', style: StyleThemeData.bold18())),
              if (controller.parameter.canEdit)
                GestureDetector(
                    onTap: () async {
                      final result = await DialogUtils.showBTSView(OrderAddFoodBTS());
                      if (result != null) {
                        controller.addFoodToPartyOrder(partyIndex, result);
                      }
                    },
                    child: Icon(Icons.add, size: 24, color: appTheme.blackColor))
            ],
          ),
          SizedBox(height: 8.h),
        ],
        ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _buildOrderItem(partyIndex, index, partyOrder.orderItems![index]),
            separatorBuilder: (context, index) => SizedBox(height: 6.h),
            itemCount: partyOrder.orderItems?.length ?? 0),
        SizedBox(height: 6.h),
        if (partyOrder.voucherPrice != null) ...[
          Text('Áp dụng mã giảm giá: Giảm ${Utils.getCurrency((partyOrder.voucherPrice ?? 0))}')
        ],
        Row(
          children: [Expanded(child: Text('total'.tr, style: StyleThemeData.bold18())), Text(Utils.getCurrency(total))],
        )
      ],
    );
  }

  Widget _buildOrderItem(int partyIndex, int itemIndex, OrderItem item) {
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
              if (controller.parameter.canEdit) ...[
                itemData(
                    title: 'quantity'.tr,
                    content: QuantityView(
                      canUpdate: true,
                      quantity: item.quantity,
                      showTitle: false,
                      updateQuantity: (quantity) => controller.updateQuantityList(partyIndex, itemIndex, quantity),
                    )),
                SizedBox(height: 4.h)
              ] else ...[
                itemData(title: 'quantity'.tr, data: (item.quantity).toString()),
                SizedBox(height: 4.h)
              ],
              itemData(title: 'total'.tr, data: Utils.getCurrency((item.quantity) * (item.food?.price ?? 0))),
            ],
          )),
          GestureDetector(
              onTap: () async {
                final result =
                    await DialogUtils.showYesNoDialog(title: 'Bạn muốn xóa món ăn khỏi party $partyIndex không?');
                if (result == true) {
                  controller.onRemoveItem(partyIndex, itemIndex);
                }
              },
              child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30)),
        ],
      ),
    );
  }

  Widget itemData({required String title, String data = '', Widget? content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title :', style: StyleThemeData.bold18()),
        SizedBox(width: 4.w),
        Expanded(child: content ?? Text(data, style: StyleThemeData.bold18())),
      ],
    );
  }
}
