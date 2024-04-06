import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/home/home_controller.dart';
import 'package:food_delivery_app/screen/list_food/list_food_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/custom_avatar.dart';
import 'package:food_delivery_app/widgets/dialog_view/add_food_dialog.dart';
import 'package:food_delivery_app/widgets/food_view.dart';
import 'package:food_delivery_app/widgets/list_vertical_item.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: padding(all: 12),
          children: [
            _buildSearchBar(),
            Obx(
              () => Padding(
                  padding: padding(vertical: 8),
                  child: controller.foodTypes.value == null
                      ? Text("food_type".tr, style: StyleThemeData.bold12())
                      : controller.foodTypes.value!.isEmpty
                          ? SizedBox()
                          : Text("food_type".tr, style: StyleThemeData.bold12())),
            ),
            Obx(
              () => Padding(
                  padding: padding(vertical: 8),
                  child: controller.foodTypes.value == null
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: controller.foodTypes.value!.map(_buildFoodType).toList()),
                        )),
            ),
            Obx(
              () => Padding(
                  padding: padding(vertical: 8),
                  child: controller.foods.value == null
                      ? Text("food".tr, style: StyleThemeData.bold12())
                      : controller.foods.value!.isEmpty
                          ? SizedBox()
                          : Text("food".tr, style: StyleThemeData.bold12())),
            ),
            Obx(
              () => Padding(
                  padding: padding(vertical: 8),
                  child: controller.foods.value == null
                      ? Center(child: CircularProgressIndicator())
                      : ListVerticalItem(
                          lineItemCount: 2,
                          items: controller.foods.value!,
                          itemBuilder: _buildFood,
                        )),
            ),
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

  Widget _buildFood(int index, FoodModel foodModel) {
    return FoodView(
      foodModel: foodModel,
      showAddBtn: true,
      onAdd: () => DialogUtils.showBTSView(AddFoodBTS(foodModel: foodModel)),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.LIST_FOOD),
      child: Container(
        padding: padding(all: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all()),
        child: Row(
          children: [
            Icon(Icons.search, size: 12.w),
            SizedBox(width: 8.w),
            Expanded(child: Text('search'.tr)),
          ],
        ),
      ),
    );
  }
}
