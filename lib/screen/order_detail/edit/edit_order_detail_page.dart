import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/cart/dialog/select_voucher_bts.dart';
import 'package:food_delivery_app/screen/order_detail/bottom_sheet/change_table_dialog.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_controller.dart';
import 'package:food_delivery_app/screen/type_details/type_details_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/bottom_button.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/normal_quantity_view.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditOrderDetailPage extends GetWidget<EditOrderDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if (isOrderNonComplete && controller.isAdmin)
                GestureDetector(
                    onTap: () async {
                      final result = await DialogUtils.showYesNoDialog(title: 'delete_order_title'.tr);
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
        final isNewParty = controller.currentPartyIndex.value >= (order.partyOrders?.length ?? 0);
        final isPartyOrderComplete = isNewParty || controller.currentPartyIndex.value == -2
            ? false
            : controller.newFoodOrder.value!.partyOrders?[controller.currentPartyIndex.value].orderStatus ==
                ORDER_STATUS.DONE;
        return Column(
          children: [
            if (!isPartyOrderComplete)
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
                        buildDropDownItem(-2, content: 'Alles'),
                        if (controller.currentTab.value == 0) ...[
                          ...(controller.newFoodOrder.value!.partyOrders ?? []).asMap().entries.map((e) =>
                              buildDropDownItem(e.key,
                                  content: 'party_index'.trParams({'number': '${(e.value.partyNumber ?? 0) + 1}'}))),
                          buildDropDownItem(-1, content: 'create_party'.tr)
                        ] else ...[
                          ...(order.partyOrders ?? []).asMap().entries.map((e) => buildDropDownItem(e.key,
                              content: 'party_index'.trParams({'number': '${(e.value.partyNumber ?? 0) + 1}'}))),
                        ]
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
                  child: Column(
                    children: [
                      if (controller.currentPartyOrder.value != null) ...[
                        if (controller.currentTab.value == 0 && controller.currentPartyIndex.value != -2) ...[
                          SizedBox(height: 6.h),
                          _buildVoucherField(controller.currentPartyOrder.value!)
                        ],
                        Row(
                          children: [
                            Expanded(child: Text('total'.tr, style: StyleThemeData.bold18())),
                            Text(Utils.getCurrency(controller.currentPartyOrder.value?.totalPrice))
                          ],
                        ),
                        SizedBox(height: 6.h),
                      ],
                      if (controller.currentTab.value == 0)
                        BottomButton(
                            isDisableCancel: false,
                            isDisableConfirm: isNewParty,
                            cancelText: isNewParty ? 'create'.tr : 'update'.tr,
                            confirmText: 'complete'.tr,
                            onConfirm: controller.onCompleteOrder,
                            onCancel: controller.updatePartyOrder),
                    ],
                  )),
          ],
        );
      }),
    );
  }

  DropdownMenuItem<int> buildDropDownItem(int index, {String? content}) {
    return DropdownMenuItem<int>(
      value: index,
      child: Text(content ?? 'party_index'.trParams({'number': '${index + 1}'})),
    );
  }

  Widget _buildPartyOrder(int partyIndex, PartyOrder partyOrder) {
    final number = (partyOrder.partyNumber ?? 0) + 1;

    final orderItems = partyOrder.orderItems ?? <OrderItem>[];
    final isPartyOrderComplete = partyOrder.orderStatus == ORDER_STATUS.DONE;

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
                Text('select_all'.tr, style: StyleThemeData.regular17()),
                Spacer(),
                GestureDetector(
                    onTap: () async {
                      final order = controller.foodOrder.value!;
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
        if (partyIndex != -2) Text('party_index'.trParams({'number': '$number'}), style: StyleThemeData.bold18()),
        SizedBox(height: 8.h),
        _buildOrderItemByGangIndex(partyIndex, partyOrder.numberOfGangs, number, orderItems, isPartyOrderComplete),
      ],
    );
  }

  Widget _buildOrderItemByGangIndex(
      int partyIndex, int maxGang, int partyNumber, List<OrderItem> orderItem, bool isPartyOrderComplete) {
    return Column(
      children: [
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
                        child: Text('gang_index'.trParams({'number': '${gangIndex + 1}'}),
                            style: StyleThemeData.bold16(color: appTheme.greyColor))),
                    if (!isPartyOrderComplete && controller.currentTab.value == 0)
                      GestureDetector(
                          onTap: () async {
                            Get.toNamed(Routes.TYPEDETAIL,
                                arguments: TypeDetailsParamter(
                                  onAddFoodToCart: (food) => controller.addFoodToPartyOrder(food, gangIndex),
                                  updateQuantityFoodItem: (quantity, food) =>
                                      controller.addFoodToPartyOrder(food, gangIndex, quantity: quantity),
                                  getQuantityFoodInCart: (food) {
                                    final orderWithFood = orderItem.firstWhereOrNull((element) =>
                                        (element.food?.foodId == food.foodId || element.foodId == food.foodId) &&
                                        element.sortOder == gangIndex);
                                    return orderWithFood?.quantity ?? 0;
                                  },
                                ));
                          },
                          child: Icon(Icons.add, size: 32, color: appTheme.blackColor)),
                    SizedBox(width: 12.w),
                    if (gangIndex > 0 &&
                        !isPartyOrderComplete &&
                        controller.isAdmin &&
                        controller.currentTab.value == 0)
                      GestureDetector(
                        onTap: () async {
                          final result =
                              await DialogUtils.showYesNoDialog(title: 'Bạn có muốn xóa gang ${gangIndex + 1} không?');
                          if (result == true) {
                            controller.onRemoveGangIndex(gangIndex);
                          }
                        },
                        child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 24),
                      )
                  ],
                ),
              ),
              ...orderItemInGang
                  .map((e) => _buildOrderItem(partyIndex, partyNumber, e, isPartyOrderComplete, gangIndex)),
            ],
          );
        }),
        if (!isPartyOrderComplete && controller.currentTab.value == 0)
          GestureDetector(
            onTap: controller.onAddNewGang,
            child: Container(
              color: appTheme.backgroundContainer,
              padding: padding(all: 12),
              child: Row(
                children: [
                  Expanded(child: Text('create_gang'.tr, style: StyleThemeData.bold16(color: appTheme.greyColor))),
                  ImageAssetCustom(imagePath: ImagesAssets.waiter, size: 24)
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderItem(int partyIndex, int partyNumber, OrderItem item, bool isPartyOrderComplete, int gangIndex) {
    var isComplete = isPartyOrderComplete;
    if (partyIndex == -2) {
      isComplete = item.partyOrderStaus == ORDER_STATUS.DONE;
    }
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
            if (controller.currentTab.value == 1 && !isComplete) ...[
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
                if (controller.currentTab.value == 0 && !isComplete) ...[
                  itemData(
                      title: 'quantity'.tr,
                      content: NormalQuantityView(
                        canUpdate: true,
                        quantity: item.quantity,
                        showTitle: false,
                        updateQuantity: (quantity) =>
                            controller.updateQuantityList(partyIndex, item, quantity, gangIndex),
                      )),
                  SizedBox(height: 4.h)
                ] else ...[
                  itemData(title: 'quantity'.tr, data: (item.quantity).toString()),
                  SizedBox(height: 4.h)
                ],
                SizedBox(height: 4.h),
                itemData(title: 'total'.tr, data: Utils.getCurrency((item.quantity) * (item.food?.price ?? 0))),
                if (partyIndex == -2) ...[
                  itemData(title: 'party'.tr, data: (item.partyIndex + 1).toString()),
                ],
              ],
            )),
            if (controller.currentTab.value == 0 && !isComplete && controller.isAdmin)
              Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        final result = await DialogUtils.showYesNoDialog(
                            title: 'delete_party_title'.trParams({'number': '$partyNumber'}));
                        if (result == true) {
                          controller.onRemoveItem(item);
                        }
                      },
                      child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30)),
                  // SizedBox(height: 12.h),
                  // GestureDetector(
                  //     onTap: () => controller.onRemoveOrderItemGang(item),
                  //     child: Icon(Icons.backspace_rounded, size: 24)),
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

  Widget _buildVoucherField(PartyOrder partyOrder) {
    String getVoucherDiscountText() {
      if (partyOrder.voucherType == DiscountType.amount) {
        return Utils.getCurrency((partyOrder.voucherPrice ?? 0));
      } else {
        return '${partyOrder.voucherPrice}%';
      }
    }

    if (partyOrder.voucherPrice == null) {
      return Row(
        children: [
          Expanded(child: Text('apply_voucher'.tr, style: StyleThemeData.bold18())),
          PrimaryButton(
              onPressed: () async {
                final result = await DialogUtils.showBTSView(SelectVoucherBTS(voucher: partyOrder.voucher));
                if (result != null && result is Voucher) {
                  controller.onUpdateVoucherOrder(result);
                }
              },
              contentPadding: padding(all: 12),
              radius: BorderRadius.circular(1000),
              child: Text(
                'select'.tr,
                style: StyleThemeData.bold14(color: appTheme.whiteText),
              ))
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: Text('apply_voucher_price'.trParams({'number': '${getVoucherDiscountText()}'}))),
          GestureDetector(onTap: () => controller.clearVoucherParty(), child: Icon(Icons.close)),
        ],
      );
    }
  }
}
