import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/list_food/list_food_parameter.dart';
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
                Padding(
                  padding: padding(horizontal: 16),
                  child: Text("food_type".tr, style: StyleThemeData.bold18()),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => controller.foodTypes.value == null
                      ? Center(child: CircularProgressIndicator())
                      // : ListVerticalItem<FoodType>(
                      //     items: controller.foodTypes.value!,
                      //     lineItemCount: 3,
                      //     itemBuilder: (index, item) => _buildFoodType(item),
                      //   ),
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
    return Padding(
      padding: padding(right: 8),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.LIST_FOOD, arguments: ListFoodParameter(foodType: foodType)),
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
}
