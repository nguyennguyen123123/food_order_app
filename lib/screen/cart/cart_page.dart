import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/screen/cart/cart_controller.dart';
import 'package:food_delivery_app/screen/cart/dialog/add_item_party_dialog.dart';
import 'package:food_delivery_app/screen/cart/dialog/select_voucher_bts.dart';
import 'package:food_delivery_app/screen/cart/widget/cart_item_view.dart';
import 'package:food_delivery_app/screen/cart/widget/empty_cart.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class CartPage extends GetWidget<CartController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final foods = controller.cartService.items.value;
      final total = controller.cartService.totalCartPrice;
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
                // leading: IconButton(onPressed: Get.back, icon: Icon(Icons.arrow_back_ios, size: 24)),
                automaticallyImplyLeading: false,
              ),
              body: hasOrderInCart
                  ? EmptyCart()
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
                              _buildListOrderItem(
                                foods,
                                numerGangs: controller.cartService.numberOfGang.value,
                                itemBuilder: (index, item, {int? gangIndex}) => CartItemView(
                                  item,
                                  updateQuantity: (quantity) => controller.updateQuantityCart(item, quantity),
                                  removeCartItem: () => controller.removeItemInOrder(item),
                                  updateNote: (note) => controller.updateCartItemNote(item, note),
                                  onRemoveGangIndex: () => controller.onRemoveGangIndexOfCartItem(item),
                                  canDeleteGang: gangIndex != null,
                                ),
                                onCreateGang: controller.cartService.onCreateNewGang,
                                onRemoveGang: controller.cartService.onRemoveGang,
                              ),
                            ],
                          ),
                        ),
                        hasOrderInCart
                            ? SizedBox()
                            : Container(
                                padding: padding(all: 12),
                                decoration: BoxDecoration(border: Border(top: BorderSide(color: appTheme.borderColor))),
                                child: Column(
                                  children: [
                                    _buildVoucherField(
                                      controller.cartService.currentVoucher.value,
                                      updateVoucher: controller.cartService.onAddVoucher,
                                      clearVoucher: () => controller.cartService.currentVoucher.value = null,
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("total".tr, style: StyleThemeData.bold18()),
                                              SizedBox(height: 8.h),
                                              Text(Utils.getCurrency(total.toDouble()),
                                                  style: StyleThemeData.regular17())
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

  Widget _buildVoucherField(
    Voucher? voucher, {
    required void Function(Voucher) updateVoucher,
    required VoidCallback clearVoucher,
  }) {
    if (voucher == null) {
      return Row(
        children: [
          Expanded(child: Text('Áp dụng voucher', style: StyleThemeData.bold18())),
          PrimaryButton(
            onPressed: () async {
              final result = await DialogUtils.showBTSView(SelectVoucherBTS());
              if (result != null && result is Voucher) {
                updateVoucher(result);
              }
            },
            contentPadding: padding(all: 12),
            radius: BorderRadius.circular(1000),
            child: Text(
              'Chọn',
              style: StyleThemeData.bold14(color: appTheme.whiteText, height: 0),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: Text("Mã voucher: ${voucher.code}")),
          if (voucher.discountType == DiscountType.amount)
            Text('Giảm ${Utils.getCurrency(voucher.discountValue)}')
          else
            Text('Giảm ${voucher.discountValue} %'),
          GestureDetector(onTap: clearVoucher, child: Icon(Icons.clear))
        ],
      );
    }
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
              Expanded(child: Text('Party ${partyIndex + 1}', style: StyleThemeData.bold18())),
              GestureDetector(
                  onTap: () async {
                    final result = await DialogUtils.showYesNoDialog(
                        title: 'Bạn muốn xóa party ${partyIndex + 1} khỏi đơn không?');
                    if (result == true) {
                      controller.onRemovePartyOrder(partyIndex);
                    }
                  },
                  child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30)),
              GestureDetector(
                  onTap: () async {
                    final result = await DialogUtils.showDialogView(
                        AddItemPartyDialog(orderItems: controller.cartService.items.value));
                    if (result != null && result is List<OrderItem>) {
                      controller.cartService.onAddItemToPartyOrder(partyIndex, result);
                    }
                  },
                  child: Icon(Icons.add, size: 32.w, color: appTheme.blackColor))
            ],
          ),
          SizedBox(height: 8.h),
          _buildListOrderItem(
            partyOrder.orderItems ?? [],
            partyIndex: partyIndex,
            itemBuilder: (index, item, {gangIndex}) => CartItemView(
              item,
              updateQuantity: (quantity) => controller.updateQuantityPartyItem(partyIndex, item, quantity),
              removeCartItem: () => controller.removeItemInPartyOrder(partyIndex, item),
              updateNote: (note) => controller.updatePartyCartItemNote(partyIndex, item, note),
              canDeleteGang: gangIndex != null,
              onRemoveGangIndex: () => controller.onRemoveGangIndexOfPartyCartItem(partyIndex, item),
            ),
            onCreateGang: () => controller.onPartyCreateGang(partyIndex),
            onRemoveGang: (gangIndex) => controller.cartService.onRemoveGangInParty(partyIndex, gangIndex),
            numerGangs: partyOrder.numberOfGangs,
          ),
          SizedBox(height: 8.h),
          if (partyOrder.orderItems?.isNotEmpty == true)
            _buildVoucherField(
              partyOrder.voucher,
              updateVoucher: (voucher) => controller.updatePartyVoucher(partyIndex, voucher),
              clearVoucher: () => controller.clearVoucherParty(partyIndex),
            ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: Text('total'.tr, style: StyleThemeData.bold18())),
              Text(Utils.getCurrency(partyOrder.totalPrice))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListOrderItem(
    List<OrderItem> foods, {
    int? partyIndex,
    EdgeInsets? paddingView,
    required Widget Function(int index, OrderItem item, {int? gangIndex}) itemBuilder,
    int numerGangs = 0,
    VoidCallback? onCreateGang,
    required void Function(int gangIndex) onRemoveGang,
  }) {
    final orderItemNoGang = foods.where((element) => element.sortOder == null).toList();

    return Column(
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: paddingView ?? padding(all: 12),
            itemBuilder: (context, index) => itemBuilder(index, orderItemNoGang[index]),
            separatorBuilder: (context, index) => SizedBox(height: 6.h),
            itemCount: orderItemNoGang.length),
        if (numerGangs > 0) ...[
          ...List.generate(numerGangs, (index) {
            final orderItemInGang = foods.where((element) => element.sortOder == index).toList();
            return Column(
              children: [
                _buildGangView(
                  gangIndex: index,
                  onRemoveGang: onRemoveGang,
                  onAddItemToGang: () async {
                    final result = await DialogUtils.showDialogView(AddItemPartyDialog(orderItems: orderItemNoGang));
                    if (result != null && result is List<OrderItem>) {
                      controller.updateOrderItemInCart(index, result, partyIndex: partyIndex);
                    }
                  },
                ),
                if (orderItemInGang.isNotEmpty)
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: paddingView ?? padding(all: 12),
                      itemBuilder: (context, i) => itemBuilder(i, orderItemInGang[i], gangIndex: index),
                      separatorBuilder: (context, index) => SizedBox(height: 6.h),
                      itemCount: orderItemInGang.length),
              ],
            );
          }),
          _buildGangView(onCreateGang: onCreateGang),
        ],
      ],
    );
  }

  Widget _buildListPartyOrder() {
    return Obx(
      () => ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => _buildPartyOrderItem(index),
          separatorBuilder: (context, index) => SizedBox(height: 8.h),
          itemCount: controller.partyOrders.length),
    );
  }

  Widget _buildGangView({
    int? gangIndex,
    VoidCallback? onCreateGang,
    VoidCallback? onAddItemToGang,
    void Function(int gangIndex)? onRemoveGang,
  }) {
    if (gangIndex != null) {
      return Container(
        color: appTheme.backgroundContainer,
        padding: padding(all: 12),
        child: Row(
          children: [
            Expanded(child: Text('Gang ${gangIndex + 1}', style: StyleThemeData.bold16(color: appTheme.greyColor))),
            GestureDetector(
                onTap: onAddItemToGang,
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.add, color: appTheme.blackColor, size: 24)),
            if (gangIndex > 0)
              GestureDetector(
                  onTap: () => onRemoveGang?.call(gangIndex),
                  behavior: HitTestBehavior.opaque,
                  child: Icon(Icons.delete, color: appTheme.errorColor, size: 24))
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onCreateGang,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: appTheme.backgroundContainer,
        padding: padding(all: 12),
        child: Row(
          children: [
            Expanded(child: Text('Tạo Gang', style: StyleThemeData.bold16(color: appTheme.greyColor))),
            ImageAssetCustom(imagePath: ImagesAssets.waiter, size: 20),
          ],
        ),
      ),
    );
  }

  Widget itemSelectTable() {
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
}
