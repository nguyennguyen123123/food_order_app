import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/screen/cart/cart_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class CartPage extends GetWidget<CartController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lên đơn", style: StyleThemeData.bold18()),
          centerTitle: true,
          leading: GestureDetector(onTap: Get.back, child: Icon(Icons.arrow_back_ios, size: 24)),
        ),
        body: Column(
          children: [
            Obx(() {
              final foods = controller.cartService.items.value;
              if (foods.isEmpty) {
                return SizedBox();
              }

              return Padding(
                padding: padding(horizontal: 12),
                child: EditTextFieldCustom(
                  label: "Số bàn",
                  hintText: 'Nhập số bàn',
                  controller: controller.tableNumberController,
                  textInputType: TextInputType.number,
                ),
              );
            }),
            Expanded(
              child: Obx(() {
                final foods = controller.cartService.items.value;
                if (foods.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: ImageAssetCustom(imagePath: ImagesAssets.emptyCart, size: 200)),
                      SizedBox(height: 12.h),
                      PrimaryButton(
                        contentPadding: padding(all: 12),
                        backgroundColor: appTheme.primaryColor,
                        borderColor: appTheme.primaryColor,
                        onPressed: Get.back,
                        child: Text('Chọn món', style: StyleThemeData.regular14(color: appTheme.whiteText)),
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  padding: padding(all: 12),
                  itemBuilder: (context, index) => _buildCartItem(index, foods[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemCount: foods.length,
                );
              }),
            ),
            Obx(
              () {
                final foods = controller.cartService.items.value;
                if (foods.isEmpty) {
                  return SizedBox();
                }
                var total = 0;
                for (final food in foods) {
                  total = (food.quantity ?? 1) * (food.food?.price ?? 0);
                }

                return Container(
                  padding: padding(all: 12),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: appTheme.borderColor))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tổng cộng:", style: StyleThemeData.bold18()),
                            SizedBox(height: 8.h),
                            Text(Utils.getCurrency(total), style: StyleThemeData.regular17())
                          ],
                        ),
                      ),
                      PrimaryButton(
                        onPressed: controller.onPlaceOrder,
                        contentPadding: padding(horizontal: 18, vertical: 12),
                        radius: BorderRadius.circular(100),
                        backgroundColor: appTheme.primaryColor,
                        borderColor: appTheme.primaryColor,
                        child: Text(
                          'confirm'.tr,
                          style: StyleThemeData.bold18(color: appTheme.whiteText),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(int index, OrderItem orderItem) {
    return Row(
      children: [
        CustomNetworkImage(url: orderItem.food?.image, size: 100, radius: 12),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderItem.food?.name ?? '', style: StyleThemeData.regular16()),
              SizedBox(height: 4.h),
              Text("Loại: " + (orderItem.food?.foodType?.name ?? '')),
              SizedBox(height: 4.h),
              Text("Giá: " + Utils.getCurrency((orderItem.food?.price ?? '') as int?)),
              SizedBox(height: 4.h),
              Text('Lưu ý: ' + (orderItem.note ?? '')),
              QuantityView(
                quantity: orderItem.quantity ?? 1,
                updateQuantity: (value) => controller.updateQuantityCart(index, value),
              )
            ],
          ),
        ),
      ],
    );
  }
}
