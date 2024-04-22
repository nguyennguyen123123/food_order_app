import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/cart/dialog/select_voucher_bts.dart';
import 'package:food_delivery_app/screen/cart/widget/cart_item_view.dart';
import 'package:food_delivery_app/screen/type_details/type_details_parameter.dart';
import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class WaiterCartPage extends GetWidget<WaiterCartController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: Text("Lên đơn cho bàn ${controller.parameter.tableNumber}".tr, style: StyleThemeData.bold18()),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: Column(
                children: [
                  Obx(
                    () => DropdownButton<int>(
                        value: controller.currentPartySelected.value,
                        items: <DropdownMenuItem<int>>[
                          _buildDropdownItem(-2, 'Alles'),
                          ...controller.cartService.partyOrders.value.asMap().entries.map((e) => _buildDropdownItem(
                                e.key,
                                'Party ${e.key + 1}',
                                canDelete: true && controller.currentPartySelected.value != e.key,
                                onDelete: () async {
                                  final result = await DialogUtils.showYesNoDialog(
                                      title: 'Bạn muốn xóa party ${e.key + 1} khỏi đơn không?');
                                  if (result == true) {
                                    controller.onRemovePartyIndex(e.key);
                                  }
                                },
                              )),
                          _buildDropdownItem(-1, 'Tạo thêm party'),
                        ],
                        onChanged: (value) => controller.onChangeCurrentPartyOrder(value ?? -2)),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Obx(() {
                          final orderItems = controller.currentOrderItems;

                          return _buildListOrderItem(
                            orderItems,
                            partyIndex: controller.currentPartySelected.value >= 0
                                ? controller.currentPartySelected.value
                                : null,
                            numerGangs: controller.numberOfGangs,
                            itemBuilder: (index, item, gangIndex) => CartItemView(
                              item,
                              updateQuantity: (quantity) => controller.updateQuantityCart(item, quantity, gangIndex),
                              removeCartItem: () => controller.removeItemInOrder(item),
                              updateNote: (note) => controller.updateCartItemNote(item, note),
                              showPartyIndex: controller.currentPartySelected.value == -2,
                              // onRemoveGangIndex: () => controller.onRemoveGangIndexOfCartItem(item),
                              // canDeleteGang: gangIndex != null,
                            ),
                            onCreateGang: controller.onCreateGang,
                            onRemoveGang: controller.onRemoveGang,
                          );
                        }),
                      ],
                    ),
                  ),
                  Obx(() {
                    final total = controller.currentCartPrice;

                    return Container(
                      padding: padding(all: 12),
                      decoration: BoxDecoration(border: Border(top: BorderSide(color: appTheme.borderColor))),
                      child: Column(
                        children: [
                          if (controller.currentPartySelected.value >= 0) ...[
                            _buildVoucherField(
                              controller.currentVoucher,
                              updateVoucher: controller.onAddVoucher,
                              clearVoucher: controller.onClearVoucher,
                            )
                          ] else ...[
                            ...controller.cartService.partyOrders.value
                                .asMap()
                                .entries
                                .map((data) => _buildVoucherField(
                                      data.value.voucher,
                                      title: 'Party ${data.key + 1}',
                                      updateVoucher: (voucher) =>
                                          controller.onAddVoucher(voucher, partyIndex: data.key),
                                      clearVoucher: () => controller.onClearVoucher(partyIndex: data.key),
                                    ))
                          ],
                          Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("total".tr, style: StyleThemeData.bold18()),
                                    SizedBox(height: 8.h),
                                    Text(Utils.getCurrency(total.toDouble()), style: StyleThemeData.regular17())
                                  ],
                                ),
                              ),
                              PrimaryButton(
                                onPressed: controller.onPlaceOrder,
                                contentPadding: padding(horizontal: 18, vertical: 12),
                                radius: BorderRadius.circular(100),
                                isDisable: controller.isEmptyCart,
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
                    );
                  })
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
      ),
    );
  }

  DropdownMenuItem<int> _buildDropdownItem(
    int value,
    String title, {
    bool canDelete = false,
    VoidCallback? onDelete,
  }) {
    return DropdownMenuItem<int>(
        value: value,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: StyleThemeData.bold16()),
          if (canDelete)
            GestureDetector(
              onTap: onDelete,
              child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 24),
            )
        ]));
  }

  Widget _buildVoucherField(
    Voucher? voucher, {
    String? title,
    required void Function(Voucher) updateVoucher,
    required VoidCallback clearVoucher,
  }) {
    if (voucher == null) {
      return Row(
        children: [
          Text(title ?? '', style: StyleThemeData.bold12()),
          Expanded(child: Text('Áp dụng voucher', style: StyleThemeData.bold18())),
          PrimaryButton(
              onPressed: () async {
                final result = await DialogUtils.showBTSView(SelectVoucherBTS(voucher: voucher));
                if (result != null && result is Voucher) {
                  updateVoucher(result);
                }
              },
              contentPadding: padding(all: 12),
              radius: BorderRadius.circular(1000),
              child: Text(
                'Chọn',
                style: StyleThemeData.bold14(color: appTheme.whiteText),
              ))
        ],
      );
    } else {
      return Row(
        children: [
          Text(title ?? '', style: StyleThemeData.bold12()),
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

  Widget _buildListOrderItem(
    List<OrderItem> foods, {
    int? partyIndex,
    EdgeInsets? paddingView,
    required Widget Function(int index, OrderItem item, int gangIndex) itemBuilder,
    int numerGangs = 0,
    VoidCallback? onCreateGang,
    required void Function(int gangIndex) onRemoveGang,
  }) {
    // final orderItemNoGang = foods.where((element) => element.sortOder == null).toList();

    return Column(
      children: [
        // ListView.separated(
        //     shrinkWrap: true,
        //     physics: NeverScrollableScrollPhysics(),
        //     padding: paddingView ?? padding(all: 12),
        //     itemBuilder: (context, index) => itemBuilder(index, orderItemNoGang[index]),
        //     separatorBuilder: (context, index) => SizedBox(height: 6.h),
        //     itemCount: orderItemNoGang.length),
        if (numerGangs > 0) ...[
          ...List.generate(numerGangs, (index) {
            final orderItemInGang = foods.where((element) => element.sortOder == index).toList();
            return Column(
              children: [
                _buildGangView(
                  gangIndex: index,
                  onRemoveGang: onRemoveGang,
                  onAddItemToGang: () async {
                    Get.toNamed(Routes.TYPEDETAIL, arguments: TypeDetailsParamter(gangIndex: index));
                    // final result = await DialogUtils.showDialogView(AddItemPartyDialog(orderItems: orderItemNoGang));
                    // if (result != null && result is List<OrderItem>) {
                    //   controller.cartService.updateOrderItemInCart(index, result, partyIndex: partyIndex);
                    // }
                  },
                ),
                if (orderItemInGang.isNotEmpty)
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: paddingView ?? padding(all: 12),
                      itemBuilder: (context, i) => itemBuilder(i, orderItemInGang[i], index),
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
}
