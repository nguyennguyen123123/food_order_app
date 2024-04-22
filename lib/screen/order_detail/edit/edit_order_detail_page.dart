import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/screen/order_detail/bottom_sheet/change_table_dialog.dart';
import 'package:food_delivery_app/screen/order_detail/bottom_sheet/order_add_food_bts.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/bottom_button.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/normal_quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditOrderDetailPage extends GetWidget<EditOrderDetailController> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        controller.onBack();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.transparentColor,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Obx(() {
            final order = controller.foodOrder.value;
            if (order == null) return SizedBox();
            final isOrderNonComplete =
                order.partyOrders!.firstWhereOrNull((element) => element.orderStatus == ORDER_STATUS.DONE) == null;
            return Row(
              children: [
                IconButton(onPressed: controller.onBack, icon: Icon(Icons.arrow_back, color: appTheme.blackColor)),
                Expanded(child: Text('detail_order'.tr, style: StyleThemeData.bold18(height: 0))),
                if (isOrderNonComplete)
                  GestureDetector(
                      onTap: () async {
                        final result = await DialogUtils.showDialogView(
                            ChangeTableDialog(currentTable: controller.foodOrder.value!.tableNumber ?? '0'));
                        if (result != null) {
                          controller.onMoveOrderToOtherTable(result);
                        }
                      },
                      child: ImageAssetCustom(imagePath: ImagesAssets.waiter, size: 30)),
                SizedBox(width: 12.w),
                if (isOrderNonComplete)
                  GestureDetector(
                      onTap: () async {
                        final result = await DialogUtils.showYesNoDialog(title: 'Bạn muốn xóa đơn này không?');
                        if (result == true) {
                          controller.onDeleteOrder();
                        }
                      },
                      child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30)),
              ],
            );
          }),
        ),
        body: Obx(() {
          final order = controller.foodOrder.value;
          if (order == null) {
            return Center(child: CircularProgressIndicator());
          }
          final isNewParty = controller.currentPartyIndex.value == order.partyOrders?.length;
          final isPartyOrderComplete = isNewParty
              ? false
              : order.partyOrders?[controller.currentPartyIndex.value].orderStatus == ORDER_STATUS.DONE;
          return Column(
            children: [
              TabBar(
                  controller: controller.tabController,
                  onTap: controller.onChangeTab,
                  tabs: controller.tabItems.asMap().entries.map((e) => Tab(child: Text(e.value))).toList()),
              Expanded(
                child: ListView(
                  padding: padding(all: 12),
                  children: [
                    itemData(title: 'order_id'.tr, data: order.orderId ?? ''),
                    SizedBox(height: 4.h),
                    itemData(title: 'table_number'.tr, data: order.tableNumber ?? ''),
                    SizedBox(height: 4.h),
                    itemData(
                        title: 'time'.tr,
                        data: DateFormat("yyyy/MM/dd HH:mm")
                            .format(DateTime.tryParse(order.createdAt ?? '') ?? DateTime.now())),
                    SizedBox(height: 8.h),
                    DropdownButton<int>(
                        value: controller.currentPartyIndex.value,
                        items: [
                          ...(order.partyOrders ?? []).asMap().entries.map((e) => buildDropDownItem(e.key)),
                          if (controller.newPartyOrder.value == null)
                            buildDropDownItem(-1, content: 'Tạo party')
                          else
                            buildDropDownItem(controller.newPartyOrder.value!.partyNumber ?? 0),
                        ],
                        onChanged: (value) => controller.onChangePartyIndex(value ?? 0)),
                    SizedBox(height: 8.h),
                    if (controller.currentPartyOrder.value != null)
                      _buildPartyOrder(controller.currentPartyIndex.value, controller.currentPartyOrder.value!)
                  ],
                ),
              ),
              if (!isPartyOrderComplete)
                Container(
                    padding: padding(all: 8),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: appTheme.borderColor))),
                    child: BottomButton(
                        isDisableCancel: false,
                        isDisableConfirm: false,
                        cancelText: isNewParty ? 'Tạo' : 'Cập nhật',
                        confirmText: 'Hoàn thành',
                        onConfirm: controller.onCompleteOrder,
                        onCancel: controller.updatePartyOrder)),
            ],
          );
        }),
      ),
    );
  }

  DropdownMenuItem<int> buildDropDownItem(int index, {String? content}) {
    return DropdownMenuItem<int>(
      value: index,
      child: Text(content ?? 'Party ${index + 1}'),
    );
  }

  Widget _buildPartyOrder(int partyIndex, PartyOrder partyOrder) {
    final order = controller.foodOrder.value!;
    final number = partyOrder.partyNumber ?? order.partyOrders?.length ?? 0;
    final total = partyOrder.totalPrice;

    final orderItems = partyOrder.orderItems ?? <OrderItem>[];
    final isPartyOrderComplete = partyOrder.orderStatus == ORDER_STATUS.DONE;
    String getVoucherDiscountText() {
      if (partyOrder.voucherType == DiscountType.amount) {
        return Utils.getCurrency((partyOrder.voucherPrice ?? 0));
      } else {
        return '${partyOrder.voucherPrice}%';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Xử lý chuyển bàn
        if (controller.currentTab.value == 1 && !isPartyOrderComplete) ...[
          Obx(() {
            final isSelectAll = controller.selectOrderItems.length == orderItems.length;
            return Row(
              children: [
                Checkbox(
                    value: isSelectAll, onChanged: (value) => controller.onUpdateAllOrderItem(isSelectAll, orderItems)),
                SizedBox(width: 12.w),
                Text('Chọn tất cả', style: StyleThemeData.regular17()),
                Spacer(),
                GestureDetector(
                    onTap: () async {
                      final result = await DialogUtils.showDialogView(ChangeTableDialog(
                        currentTable: order.tableNumber ?? '',
                        isLimitTableHasOrder: false,
                      ));
                      if (result != null) {
                        controller.onMovePartyToOtherTable(result);
                      }
                    },
                    child: ImageAssetCustom(imagePath: ImagesAssets.waiter, size: 30)),
              ],
            );
          })
        ],
        Text('party number: $number', style: StyleThemeData.bold18()),
        // Row(
        //   children: [
        //     Expanded(child: Text('party number: $number', style: StyleThemeData.bold18())),
        //     if (!isPartyOrderComplete)
        //       GestureDetector(
        //           onTap: () async {
        //             final result = await DialogUtils.showBTSView(OrderAddFoodBTS());
        //             if (result != null) {
        //               controller.addFoodToPartyOrder(result);
        //             }
        //           },
        //           child: Icon(Icons.add, size: 24, color: appTheme.blackColor))
        //   ],
        // ),
        SizedBox(height: 8.h),
        _buildOrderItemByGangIndex(partyIndex, partyOrder.numberOfGangs, number, orderItems, isPartyOrderComplete),
        SizedBox(height: 6.h),
        if (partyOrder.voucherPrice != null) ...[Text('Áp dụng mã giảm giá: Giảm ${getVoucherDiscountText()}')],
        Row(
          children: [Expanded(child: Text('total'.tr, style: StyleThemeData.bold18())), Text(Utils.getCurrency(total))],
        )
      ],
    );
  }

  Widget _buildOrderItemByGangIndex(
      int partyIndex, int maxGang, int partyNumber, List<OrderItem> orderItem, bool isPartyOrderComplete) {
    final orderItemNoGang = orderItem.where((element) => element.sortOder == null).toList();

    return Column(
      children: [
        ...orderItemNoGang.map((e) => _buildOrderItem(partyIndex, partyNumber, e, isPartyOrderComplete)),
        ...List.generate(maxGang + 1, (gangIndex) {
          final orderItemInGang = orderItem.where((element) => element.sortOder == gangIndex).toList();
          return Column(
            children: [
              Container(
                color: appTheme.backgroundContainer,
                padding: padding(all: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text('Gang ${gangIndex + 1}', style: StyleThemeData.bold16(color: appTheme.greyColor))),
                    // GestureDetector(
                    //   onTap: () async {
                    //     final result =
                    //         await DialogUtils.showDialogView(AddItemPartyDialog(orderItems: orderItemNoGang));
                    //     if (result != null && result is List<OrderItem>) {
                    //       controller.onAddOrderToGang(gangIndex, result);
                    //     }
                    //   },
                    //   child: Icon(Icons.add, size: 24),
                    // ),
                    GestureDetector(
                        onTap: () async {
                          final result = await DialogUtils.showBTSView(OrderAddFoodBTS());
                          if (result != null) {
                            controller.addFoodToPartyOrder(result, gangIndex: gangIndex);
                          }
                        },
                        child: Icon(Icons.add, size: 24, color: appTheme.blackColor)),
                    SizedBox(width: 6.w),
                    if (gangIndex > 0)
                      GestureDetector(
                        onTap: () => controller.onRemoveGangIndex(gangIndex),
                        child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 24),
                      )
                  ],
                ),
              ),
              ...orderItemInGang.map((e) => _buildOrderItem(partyIndex, partyNumber, e, isPartyOrderComplete)),
            ],
          );
        }),
        GestureDetector(
          onTap: controller.onAddNewGang,
          child: Container(
            color: appTheme.backgroundContainer,
            padding: padding(all: 12),
            child: Row(
              children: [
                Expanded(child: Text('Tạo gang', style: StyleThemeData.bold16(color: appTheme.greyColor))),
                ImageAssetCustom(imagePath: ImagesAssets.waiter, size: 24)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(int partyIndex, int partyNumber, OrderItem item, bool isPartyOrderComplete) {
    return GestureDetector(
      onTap: () {
        if (controller.currentTab.value == 1) {
          final isSelected = controller.selectOrderItems.contains(item.orderItemId);
          controller.onAddItemToSelect(isSelected, item);
        }
      },
      child: Padding(
        padding: padding(bottom: 12),
        child: Row(
          children: [
            if (controller.currentTab.value == 1) ...[
              Obx(
                () {
                  final isSelected = controller.selectOrderItems.contains(item.orderItemId);
                  return Checkbox(
                      value: isSelected, onChanged: (value) => controller.onAddItemToSelect(isSelected, item));
                },
              )
            ],
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
                if (controller.currentTab.value == 0 && !isPartyOrderComplete) ...[
                  itemData(
                      title: 'quantity'.tr,
                      content: NormalQuantityView(
                        canUpdate: true,
                        quantity: item.quantity,
                        showTitle: false,
                        updateQuantity: (quantity) => controller.updateQuantityList(partyIndex, item, quantity),
                      )),
                  SizedBox(height: 4.h)
                ] else ...[
                  itemData(title: 'quantity'.tr, data: (item.quantity).toString()),
                  SizedBox(height: 4.h)
                ],
                SizedBox(height: 4.h),
                itemData(title: 'total'.tr, data: Utils.getCurrency((item.quantity) * (item.food?.price ?? 0))),
              ],
            )),
            if (controller.currentTab.value == 0 && !isPartyOrderComplete)
              Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        final result = await DialogUtils.showYesNoDialog(
                            title: 'Bạn muốn xóa món ăn khỏi party $partyNumber không?');
                        if (result == true) {
                          controller.onRemoveItem(item);
                        }
                      },
                      child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30)),
                  SizedBox(height: 12.h),
                  GestureDetector(
                      onTap: () => controller.onRemoveOrderItemGang(item),
                      child: Icon(Icons.backspace_rounded, size: 24)),
                ],
              ),
          ],
        ),
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
