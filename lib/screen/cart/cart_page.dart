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
    return Obx(() {
      final foods = controller.cartService.items.value;
      var total = 0;
      for (final food in foods) {
        total = (food.quantity ?? 1) * (food.food?.price ?? 0);
      }
      return Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: Text("place_order_title".tr, style: StyleThemeData.bold18()),
                centerTitle: true,
                leading: GestureDetector(onTap: Get.back, child: Icon(Icons.arrow_back_ios, size: 24)),
              ),
              body: Column(
                children: [
                  foods.isEmpty
                      ? SizedBox()
                      : Padding(
                          padding: padding(horizontal: 12),
                          child: EditTextFieldCustom(
                            label: "table_number".tr,
                            hintText: 'enter_table_number'.tr,
                            controller: controller.tableNumberController,
                            isShowErrorText: controller.isValidateForm.value,
                            isRequire: true,
                            textInputType: TextInputType.number,
                          ),
                        ),
                  Expanded(
                      child: foods.isEmpty
                          ? Column(
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
                                    child: Text('select_food'.tr,
                                        style: StyleThemeData.regular14(color: appTheme.whiteText)))
                              ],
                            )
                          : ListView.separated(
                              padding: padding(all: 12),
                              itemBuilder: (context, index) => _buildCartItem(index, foods[index]),
                              separatorBuilder: (context, index) => SizedBox(height: 8.h),
                              itemCount: foods.length)),
                  foods.isEmpty
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
                                  Text(Utils.getCurrency(total), style: StyleThemeData.regular17())
                                ],
                              )),
                              PrimaryButton(
                                  onPressed: controller.onPlaceOrder,
                                  contentPadding: padding(horizontal: 18, vertical: 12),
                                  radius: BorderRadius.circular(100),
                                  backgroundColor: appTheme.primaryColor,
                                  borderColor: appTheme.primaryColor,
                                  child: Text(
                                    'confirm'.tr,
                                    style: StyleThemeData.bold18(color: appTheme.whiteText),
                                  ))
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

  Widget _buildCartItem(int index, OrderItem orderItem) {
    return Row(children: [
      CustomNetworkImage(url: orderItem.food?.image, size: 100, radius: 12),
      SizedBox(width: 8.w),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(orderItem.food?.name ?? '', style: StyleThemeData.regular16()),
          Text("type".tr + (orderItem.food?.foodType?.name ?? '')),
          Text('note_text'.tr + (orderItem.note ?? '')),
          QuantityView(
            quantity: orderItem.quantity ?? 1,
            updateQuantity: (value) => controller.updateQuantityCart(index, value),
          )
        ],
      ))
    ]);
  }
}
