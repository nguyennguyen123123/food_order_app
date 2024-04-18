import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/screen/product/product_details_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/dialog_view/add_food_dialog.dart';
import 'package:food_delivery_app/widgets/food_view.dart';
import 'package:food_delivery_app/widgets/list_vertical_item.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends GetWidget<ProductDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CustomNetworkImage(
                  url: controller.foodParametar?.image ?? '',
                  height: 375,
                  width: double.infinity,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                Positioned(
                  top: 40,
                  left: 6,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Container(
                      padding: padding(all: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.textDesColor,
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.arrow_back_ios_new_outlined, color: appTheme.whiteText, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: padding(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.foodParametar?.name ?? '', style: StyleThemeData.bold19()),
                    SizedBox(height: 12.h),
                    Text(
                      r'$' + '${controller.foodParametar?.price}',
                      style: StyleThemeData.bold16(color: appTheme.appColor),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'food_type'.tr + ': ' + '${controller.foodParametar?.foodType?.name}',
                      style: StyleThemeData.bold16(),
                    ),
                    SizedBox(height: 12.h),
                    InkWell(
                      onTap: () => DialogUtils.showBTSView(AddFoodBTS(foodModel: controller.foodParametar!)),
                      child: Container(
                        width: Get.size.width.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: appTheme.appColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'add_to_cart'.tr,
                          style: StyleThemeData.bold14(height: 0, color: appTheme.whiteText),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text('description'.tr + ':', style: StyleThemeData.regular14(color: appTheme.textDesColor)),
                    SizedBox(height: 4.h),
                    Text(controller.foodParametar?.description ?? '', style: StyleThemeData.regular16()),
                    SizedBox(height: 24.h),
                    itemDivider(),
                    Obx(
                      () => controller.foods.value == null
                          ? Center(child: CircularProgressIndicator())
                          : ListVerticalItem<FoodModel>(
                              items: controller.foods.value!,
                              itemBuilder: (index, item) => Padding(
                                padding: padding(vertical: 12),
                                child: FoodView(foodModel: item, showAddBtn: true),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row itemDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: appTheme.background700Color,
          width: 50.w,
          height: 1.5.h,
        ),
        SizedBox(width: 4.w),
        Text('product_suggestions'.tr, style: StyleThemeData.regular14(height: 0)),
        SizedBox(width: 4.w),
        Container(
          color: appTheme.background700Color,
          width: 50.w,
          height: 1.5.h,
        ),
      ],
    );
  }
}
