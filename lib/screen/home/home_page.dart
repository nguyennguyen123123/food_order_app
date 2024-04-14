import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/home/home_controller.dart';
import 'package:food_delivery_app/screen/list_food/list_food_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/icons_assets.dart';
import 'package:food_delivery_app/widgets/custom_avatar.dart';
import 'package:food_delivery_app/widgets/default_box_shadow.dart';
import 'package:food_delivery_app/widgets/food_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.foodAppBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: padding(horizontal: 12),
              child: _buildSearchBar(),
            ),
            Obx(
              () => Padding(
                padding: padding(vertical: 8, horizontal: 12),
                child: controller.foodTypes.value == null
                    ? Text("food_type".tr, style: StyleThemeData.bold18())
                    : controller.foodTypes.value!.isEmpty
                        ? SizedBox()
                        : Text(
                            "food_type".tr,
                            style: StyleThemeData.bold18(),
                          ),
              ),
            ),
            Obx(
              () => Padding(
                padding: padding(all: 12),
                child: controller.foodTypes.value == null
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: controller.foodTypes.value!.map(_buildFoodType).toList()),
                      ),
              ),
            ),
            Obx(() {
              if (controller.foods.value == null) {
                return Center(child: CircularProgressIndicator());
              }

              final groupedFood = controller.groupFoodByType();
              return groupedFood.isEmpty
                  ? Center(child: Text('no_data_available'.tr, style: StyleThemeData.bold18()))
                  : Expanded(
                      child: ListView(
                        children: groupedFood.entries.map((entry) {
                          final foodType = entry.value.first.foodType?.name ?? '';
                          final foods = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: padding(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'food_type'.tr + ': $foodType',
                                      style: StyleThemeData.bold18(color: appTheme.textPrimaryColor),
                                    ),
                                    InkWell(
                                      onTap: () => Get.toNamed(
                                        Routes.LIST_FOOD,
                                        arguments: ListFoodParameter(foodType: entry.value.first.foodType),
                                      ),
                                      child: Text(
                                        'view_all'.tr,
                                        style: StyleThemeData.regular16(color: appTheme.appColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: foods
                                      .map(
                                        (data) => Container(
                                          width: 200.w,
                                          height: Get.size.height / 3.h,
                                          padding: padding(horizontal: 12, vertical: 12),
                                          child: FoodView(foodModel: data, showAddBtn: true),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
            }),
            // Obx(
            //   () => Padding(
            //     padding: padding(vertical: 8),
            //     child: controller.foods.value == null
            //         ? Text("food".tr, style: StyleThemeData.bold12())
            //         : controller.foods.value!.isEmpty
            //             ? SizedBox()
            //             : Text(
            //                 "food".tr,
            //                 style: StyleThemeData.bold12(),
            //               ),
            //   ),
            // ),
            // Obx(
            //   () => Padding(
            //     padding: padding(vertical: 8),
            //     child: controller.foods.value == null
            //         ? Center(child: CircularProgressIndicator())
            //         : ListVerticalItem<FoodModel>(
            //             lineItemCount: 2,
            //             items: controller.foods.value!,
            //             itemBuilder: (index, item) => FoodView(foodModel: item, showAddBtn: true),
            //           ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodType(FoodType foodType) {
    return Padding(
      padding: padding(right: 8),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.LIST_FOOD, arguments: ListFoodParameter(foodType: foodType)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAvatar(url: foodType.image),
            SizedBox(height: 4.h),
            Text(foodType.name ?? '', style: StyleThemeData.regular16())
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.toNamed(Routes.LIST_FOOD),
            child: Container(
              padding: padding(all: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: appTheme.whiteText,
                boxShadow: defaultBoxShadow(),
              ),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      child: SvgPicture.asset(IconAssets.searchIcon, width: 18.w, height: 18.h),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'search'.tr,
                    style: StyleThemeData.regular14(color: appTheme.textDesColor, height: 0),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => Padding(
            padding: padding(left: 10),
            child: IconButton(
              onPressed: () => Get.toNamed(Routes.CART),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(IconAssets.shoppingCartIcon),
                  if (controller.cartService.items.value.isNotEmpty)
                    Positioned(
                      top: -12,
                      right: -10,
                      child: Container(
                        padding: padding(all: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.errorColor,
                        ),
                        child: Text(
                          controller.cartService.items.value.length.toString(),
                          style: StyleThemeData.regular14(height: 0, color: appTheme.whiteText),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
