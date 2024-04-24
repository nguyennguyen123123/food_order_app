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
                title: Text("waiter_cart_title".trParams({'number': '${controller.parameter.tableNumber}'}),
                    style: StyleThemeData.bold18()),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: Column(
                children: [
                  Obx(
                    () => DropdownButton<int>(
                        value: controller.currentPartySelected.value,
                        items: <DropdownMenuItem<int>>[
                          _buildDropdownItem(-2, 'alles'.tr),
                          ...controller.cartService.partyOrders.value.asMap().entries.map((e) => _buildDropdownItem(
                                e.key,
                                'party_index'.trParams({'number': '${e.key + 1}'}),
                                canDelete: true && controller.currentPartySelected.value != e.key,
                                onDelete: () async {
                                  final result = await DialogUtils.showYesNoDialog(
                                      title: 'delete_party_title'.trParams({'number': '${e.key + 1}'}));
                                  if (result == true) {
                                    controller.onRemovePartyIndex(e.key);
                                  }
                                },
                              )),
                          _buildDropdownItem(-1, 'create_party'.tr),
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
                            if (controller.cartService.partyOrders.value.length == 3) ...[
                              ...controller.cartService.partyOrders.value
                                  .asMap()
                                  .entries
                                  .map((data) => _buildVoucherField(
                                        data.value.voucher,
                                        title: 'party_index'.trParams({'number': '${data.key + 1}'}),
                                        updateVoucher: (voucher) =>
                                            controller.onAddVoucher(voucher, partyIndex: data.key),
                                        clearVoucher: () => controller.onClearVoucher(partyIndex: data.key),
                                      ))
                            ] else ...[
                              SizedBox(
                                height: 90.h,
                                width: double.infinity,
                                child: ListView.separated(
                                  itemCount: controller.cartService.partyOrders.value.length,
                                  separatorBuilder: (context, index) => Divider(),
                                  itemBuilder: (context, index) {
                                    final data = controller.cartService.partyOrders.value[index];
                                    return _buildVoucherField(
                                      data.voucher,
                                      title: 'party_index'.trParams({'number': '${index + 1}'}),
                                      updateVoucher: (voucher) => controller.onAddVoucher(voucher, partyIndex: index),
                                      clearVoucher: () => controller.onClearVoucher(partyIndex: index),
                                    );
                                  },
                                ),
                              )
                            ]
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
          Expanded(child: Text('apply_voucher'.tr, style: StyleThemeData.bold18())),
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
                'select'.tr,
                style: StyleThemeData.bold14(color: appTheme.whiteText),
              ))
        ],
      );
    } else {
      return Row(
        children: [
          Text(title ?? '', style: StyleThemeData.bold12()),
          Expanded(child: Text("voucher_code".trParams({'code': '${voucher.code}'}))),
          if (voucher.discountType == DiscountType.amount)
            Text('voucher_price'.trParams({'number': '${Utils.getCurrency(voucher.discountValue)}'}))
          else
            Text('voucher_percentage'.trParams({'number': '${voucher.discountValue}'})),
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
          ...List.generate(numerGangs, (gangIndex) {
            final orderItemInGang = foods.where((element) => element.sortOder == gangIndex).toList();
            return Column(
              children: [
                _buildGangView(
                  gangIndex: gangIndex,
                  onRemoveGang: onRemoveGang,
                  onAddItemToGang: () async {
                    Get.toNamed(Routes.TYPEDETAIL,
                        arguments: TypeDetailsParamter(
                          // gangIndex: index,
                          onAddFoodToCart: (food) => controller.cartService.onAddItemToCart(food, gangIndex),
                          updateQuantityFoodItem: (quantity, food) =>
                              controller.cartService.onUpdateQuantityItemInCart(quantity, food, gangIndex),
                          getQuantityFoodInCart: (item) {
                            final listItems = controller.cartService.currentListItems;
                            final i = listItems.indexWhere(
                                (element) => element.food?.foodId == item.foodId && gangIndex == element.sortOder);
                            return i != -1 ? listItems[i].quantity : 0;
                          },
                        ));
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
                      itemBuilder: (context, i) => itemBuilder(i, orderItemInGang[i], gangIndex),
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
            Expanded(
                child: Text('gang_index'.trParams({'number': '${gangIndex + 1}'}),
                    style: StyleThemeData.bold16(color: appTheme.greyColor))),
            GestureDetector(
                onTap: onAddItemToGang,
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.add, color: appTheme.blackColor, size: 32)),
            if (gangIndex > 0)
              Padding(
                padding: padding(right: 12),
                child: GestureDetector(
                    onTap: () => onRemoveGang?.call(gangIndex),
                    behavior: HitTestBehavior.opaque,
                    child: Icon(Icons.delete, color: appTheme.errorColor, size: 24)),
              )
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
            Expanded(child: Text('create_gang'.tr, style: StyleThemeData.bold16(color: appTheme.greyColor))),
            ImageAssetCustom(imagePath: ImagesAssets.waiter, size: 20),
          ],
        ),
      ),
    );
  }
}
