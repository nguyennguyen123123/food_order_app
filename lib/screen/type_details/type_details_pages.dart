import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/product/product_details_parameter.dart';
import 'package:food_delivery_app/screen/type_details/type_details_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/custom_avatar.dart';
import 'package:food_delivery_app/widgets/food_view.dart';
import 'package:food_delivery_app/widgets/list_vertical_item.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';

class TypeDetailsPages extends GetWidget<TypeDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: appTheme.blackText)),
            Text('Danh sách phân loại sản phẩm', style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.onGetFood,
        child: SingleChildScrollView(
          child: Padding(
            padding: padding(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: padding(horizontal: 16),
                      child: Row(
                        children: controller.selectedFoodTypes.map(_buildSelectedFoodType).toList(),
                      ),
                    ),
                  ),
                ),
                Obx(() => SizedBox(height: controller.selectedFoodTypes.isNotEmpty ? 12.h : null)),
                Padding(
                  padding: padding(horizontal: 16),
                  child: Text("food_type".tr, style: StyleThemeData.bold18()),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => controller.foodTypes.value == null
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: padding(horizontal: 16),
                            child: Row(children: controller.foodTypes.value!.map(_buildFoodType).toList()),
                          ),
                        ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: padding(horizontal: 16),
                  child: Text("food".tr, style: StyleThemeData.bold18()),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => controller.foods.value == null
                      ? Center(child: CircularProgressIndicator())
                      : LoadMore(
                          delegate: LoadMoreDelegateCustom(),
                          onLoadMore: controller.onLoadMoreFoods,
                          child: Padding(
                            padding: padding(horizontal: 12),
                            child: ListVerticalItem<FoodModel>(
                              items: controller.foods.value!,
                              itemBuilder: (index, item) => InkWell(
                                onTap: () => Get.toNamed(
                                  Routes.PRODUCTDETAILS,
                                  arguments: ProductDetailsParameter(foodModel: item),
                                ),
                                child: Padding(
                                  padding: padding(vertical: 12),
                                  child: FoodView(foodModel: item, showAddBtn: true),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodType(FoodType foodType) {
    print(foodType.parentTypeId);
    return Padding(
      padding: padding(right: 8),
      child: GestureDetector(
        onTap: () {
          if (controller.selectedFoodTypes.contains(foodType)) {
            controller.removeFoodType(foodType);
            if (controller.selectedFoodTypes.first.parentTypeId != null) {
              controller.onRefresh(controller.selectedFoodTypes.first.parentTypeId ?? '');
            } else {
              controller.onRefresh(controller.selectedFoodTypes.first.typeId ?? '');
            }
          } else {
            controller.addFoodType(foodType);
            if (foodType.parentTypeId != null) {
              controller.onRefresh(foodType.parentTypeId ?? '');
            } else {
              controller.onRefresh(foodType.typeId ?? '');
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAvatar(
              radius: 8,
              size: 100,
              url: foodType.image,
            ),
            SizedBox(height: 4.h),
            Text(foodType.name ?? '', style: StyleThemeData.regular16())
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFoodType(FoodType foodType) {
    return Stack(
      children: [
        Padding(
          padding: padding(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAvatar(
                radius: 100,
                size: 65,
                url: foodType.image,
              ),
              SizedBox(height: 4),
              Text(foodType.name ?? '', style: StyleThemeData.regular16())
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              controller.removeFoodType(foodType);
              if (controller.selectedFoodTypes.first.parentTypeId != null) {
                controller.onRefresh(controller.selectedFoodTypes.first.parentTypeId ?? '');
              } else {
                controller.onRefresh(controller.selectedFoodTypes.first.typeId ?? '');
              }
            },
            child: Container(
              padding: padding(all: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme.textDesColor,
              ),
              child: Icon(Icons.clear, color: appTheme.whiteText, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
