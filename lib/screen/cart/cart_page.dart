import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/screen/cart/cart_controller.dart';
import 'package:food_delivery_app/screen/cart/widget/add_item_party_dialog.dart';
import 'package:food_delivery_app/screen/cart/widget/edit_reason_bottom_sheet.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class CartPage extends GetWidget<CartController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final foods = controller.cartService.items.value;
      var total = 0.0;
      for (final food in foods) {
        total += food.quantity * (food.food?.price ?? 0);
      }
      for (final party in controller.partyOrders) {
        total += party.totalPrice;
      }
      final hasOrderInCart = (foods.isEmpty && controller.partyOrders.isEmpty) ||
          (foods.isEmpty &&
              controller.partyOrders.isNotEmpty &&
              (controller.partyOrders.first.orderItems?.isEmpty ?? true));
      return Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: Text("place_order_title".tr, style: StyleThemeData.bold18()),
                centerTitle: true,
                leading: IconButton(onPressed: Get.back, icon: Icon(Icons.arrow_back_ios, size: 24)),
              ),
              body: hasOrderInCart
                  ? _buildEmptyCart()
                  : Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Padding(
                                padding: padding(horizontal: 16, top: 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("table_number".tr, style: StyleThemeData.bold14()),
                                ),
                              ),
                              Padding(
                                padding: padding(top: 4, left: 16, right: 16, bottom: 16),
                                child: controller.tableList.isEmpty
                                    ? Center(child: CircularProgressIndicator())
                                    : itemSelectTable(),
                              ),
                              if (controller.isValidateForm.value && controller.selectedValue.value == null) ...[],
                              GestureDetector(
                                onTap: () => controller.onCreateNewPartyOrder(),
                                child: Container(
                                  color: appTheme.background,
                                  padding: padding(all: 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add, size: 16.w, color: appTheme.blackColor),
                                      SizedBox(width: 8.w),
                                      Expanded(child: Text('Tạo party', style: StyleThemeData.regular17()))
                                    ],
                                  ),
                                ),
                              ),
                              _buildListPartyOrder(),
                              if (controller.partyOrders.length > 0) Divider(height: 1, color: appTheme.borderColor),
                              _buildListOrderItem(foods),
                            ],
                          ),
                        ),
                        hasOrderInCart
                            ? SizedBox()
                            : Container(
                                padding: padding(all: 12),
                                decoration: BoxDecoration(border: Border(top: BorderSide(color: appTheme.borderColor))),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("total".tr, style: StyleThemeData.bold18()),
                                          SizedBox(height: 8.h),
                                          Text(Utils.getCurrency(total.toInt()), style: StyleThemeData.regular17())
                                        ],
                                      ),
                                    ),
                                    PrimaryButton(
                                      onPressed: controller.onPlaceOrder,
                                      contentPadding: padding(horizontal: 18, vertical: 12),
                                      radius: BorderRadius.circular(100),
                                      isDisable: controller.selectedValue.value == null,
                                      backgroundColor: appTheme.primaryColor,
                                      borderColor: appTheme.primaryColor,
                                      child: Text(
                                        'confirm'.tr,
                                        style: StyleThemeData.bold18(color: appTheme.whiteText, height: 0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
            ),
          ),
          if (controller.isLoading.value) ...[
            Container(
              width: double.infinity,
              height: double.infinity,
              color: appTheme.blackColor.withOpacity(0.2),
            ),
          ]
        ],
      );
    });
  }

  Widget _buildListOrderItem(List<OrderItem> foods) {
    return ListView.separated(
      shrinkWrap: true,
      padding: padding(all: 12),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildCartItem(
        index,
        foods[index],
        updateQuantity: controller.updateQuantityCart,
        removeCartItem: () => controller.removeItemInOrder(index),
        updateNote: (note) => controller.updateCartItemNote(index, note),
      ),
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemCount: foods.length,
    );
  }

  Widget _buildListPartyOrder() {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _buildPartyOrderItem(index),
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemCount: controller.partyOrders.length);
  }

  Widget _buildEmptyCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: ImageAssetCustom(imagePath: ImagesAssets.emptyCart, size: 200)),
        SizedBox(height: 12.h),
        PrimaryButton(
          contentPadding: padding(all: 12),
          backgroundColor: appTheme.primaryColor,
          borderColor: appTheme.primaryColor,
          onPressed: Get.back,
          child: Text(
            'select_food'.tr,
            style: StyleThemeData.regular14(color: appTheme.whiteText),
          ),
        ),
      ],
    );
  }

  Widget _buildPartyOrderItem(int partyIndex) {
    final partyOrder = controller.partyOrders[partyIndex];
    return Padding(
      padding: padding(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Party $partyIndex', style: StyleThemeData.bold18())),
              GestureDetector(
                  onTap: () async {
                    final result = await DialogUtils.showDialogView(AddItemPartyDialog());
                    if (result != null && result is List<OrderItem>) {
                      controller.cartService.onAddItemToPartyOrder(partyIndex, result);
                    }
                  },
                  child: Icon(Icons.add, size: 32.w, color: appTheme.blackColor))
            ],
          ),
          SizedBox(height: 8.h),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => _buildCartItem(
                    i,
                    partyOrder.orderItems![i],
                    updateQuantity: (i, quantity) => controller.updateQuantityPartyItem(partyIndex, i, quantity),
                    removeCartItem: () => controller.removeItemInPartyOrder(partyIndex, i),
                    updateNote: (note) => controller.updatePartyCartItemNote(partyIndex, i, note),
                  ),
              separatorBuilder: (context, index) => SizedBox(height: 4.h),
              itemCount: partyOrder.orderItems?.length ?? 0),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: Text('total'.tr, style: StyleThemeData.bold18())),
              Text(Utils.getCurrency(partyOrder.totalPrice.toInt()))
            ],
          )
        ],
      ),
    );
  }

  Container itemSelectTable() {
    return Container(
      padding: padding(all: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: appTheme.blackColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'select_table_number'.tr,
            style: StyleThemeData.regular16(height: 0),
          ),
          iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down_outlined)),
          items: controller.tableList
              .map((item) => DropdownMenuItem<String>(
                    value: item.tableId,
                    child: Text(
                      item.tableNumber.toString(),
                      style: StyleThemeData.regular16(height: 0),
                    ),
                  ))
              .toList(),
          value: controller.selectedValue.value?.tableId,
          onChanged: (value) {
            controller.selectedValue.value = controller.tableList.firstWhere((item) => item.tableId == value);
          },
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 40.h,
            width: Get.size.width.w,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 800,
            offset: const Offset(0, -10),
          ),
          menuItemStyleData: MenuItemStyleData(height: 40.h),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              controller.searchController.clear();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCartItem(
    int index,
    OrderItem orderItem, {
    required Function(int index, int quantity) updateQuantity,
    required Function() removeCartItem,
    required Function(String note) updateNote,
  }) {
    return Row(
      children: [
        CustomNetworkImage(url: orderItem.food?.image, size: 100),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderItem.food?.name ?? '', style: StyleThemeData.regular16()),
              Text("type".tr + (orderItem.food?.foodType?.name ?? '')),
              Text('price'.tr + ' ' + Utils.getCurrency(orderItem.food?.price ?? 0)),
              Text('note_text'.tr + (orderItem.note ?? '')),
              QuantityView(
                quantity: orderItem.quantity,
                updateQuantity: (value) => updateQuantity(index, value),
              )
            ],
          ),
        ),
        Column(
          children: [
            GestureDetector(
                onTap: () async {
                  final result = await DialogUtils.showYesNoDialog(title: 'Bạn muốn xóa món ăn này khỏi đơn không?');
                  if (result == true) {
                    removeCartItem();
                  }
                },
                child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30)),
            SizedBox(height: 8.h),
            GestureDetector(
                onTap: () async {
                  final result =
                      await DialogUtils.showBTSView(EditReasonBottomSheet(reason: orderItem.note ?? ''), isWrap: true);
                  if (result != null && result is String) {
                    updateNote(result);
                  }
                },
                child: Icon(Icons.edit))
          ],
        )
      ],
    );
  }
}
