import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/screen/cart/cart_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
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
                leading: IconButton(onPressed: Get.back, icon: Icon(Icons.arrow_back_ios, size: 24)),
              ),
              body: foods.isEmpty
                  ? Column(
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
                    )
                  : Column(
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
                          child: controller.tableList.isEmpty ? CircularProgressIndicator() : itemSeleteTable(),
                        ),
                        // foods.isEmpty
                        //     ? SizedBox()
                        //     : Padding(
                        //         padding: padding(horizontal: 12),
                        //         child: EditTextFieldCustom(
                        //           label: "table_number".tr,
                        //           hintText: 'enter_table_number'.tr,
                        //           controller: controller.tableNumberController,
                        //           isShowErrorText: controller.isValidateForm.value,
                        //           isRequire: true,
                        //           textInputType: TextInputType.number,
                        //         ),
                        //       ),
                        Expanded(
                          child: ListView.separated(
                            padding: padding(all: 12),
                            itemBuilder: (context, index) => _buildCartItem(index, foods[index]),
                            separatorBuilder: (context, index) => SizedBox(height: 8.h),
                            itemCount: foods.length,
                          ),
                        ),
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

  Container itemSeleteTable() {
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
          value: controller.selectedValue.value.tableId,
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
              Text("type".tr + (orderItem.food?.foodType?.name ?? '')),
              Text('note_text'.tr + (orderItem.note ?? '')),
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
