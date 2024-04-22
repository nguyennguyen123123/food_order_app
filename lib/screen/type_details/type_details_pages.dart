import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
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
            Text('list_of_products'.tr, style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
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
                        children: controller.selectedFoodTypes
                            .asMap()
                            .entries
                            .map((e) => _buildSelectedFoodType(
                                e.key, e.value, e.key == controller.selectedFoodTypes.length - 1))
                            .toList(),
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
                      : LoadMore(
                          onLoadMore: controller.onLoadMoreType,
                          delegate: LoadMoreDelegateCustom(),
                          child: SizedBox(
                            height: 140.h,
                            width: double.infinity,
                            child: ListView.separated(
                              padding: padding(horizontal: 16),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => _buildFoodType(controller.foodTypes.value![index]),
                              separatorBuilder: (context, index) => SizedBox(width: 16.w),
                              itemCount: controller.foodTypes.value!.length,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: padding(horizontal: 16),
                  child: Text("food".tr, style: StyleThemeData.bold18()),
                ),
                SizedBox(height: 12.h),
                Obx(() {
                  if (controller.foods.value == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ValueListenableBuilder(
                    valueListenable: controller.orderCartNotifier,
                    builder: (context, _, __) => LoadMore(
                      delegate: LoadMoreDelegateCustom(),
                      onLoadMore: controller.onLoadMoreFoods,
                      child: Padding(
                        padding: padding(horizontal: 12),
                        child: ListVerticalItem<FoodModel>(
                            items: controller.foods.value!,
                            itemBuilder: (index, item) {
                              // final listItems = controller.cartService.currentListItems;
                              // final index = listItems.indexWhere((element) =>
                              //     element.food?.foodId == item.foodId &&
                              //     controller.paramter.gangIndex == element.sortOder);
                              // final quantity = index != -1 ? listItems[index].quantity : 0;
                              return InkWell(
                                child: Padding(
                                  padding: padding(vertical: 12),
                                  child: FoodView(
                                    foodModel: item,
                                    showAddBtn: true,
                                    onAdd: () => controller.addItemToCart(item),
                                    quantity: controller.paramter.getQuantityFoodInCart(item),
                                    showChangeOnQuantity: true,
                                    updateQuantity: (quantity) => controller.updateQuantityCartItem(quantity, item),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  );
                }),
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
        onTap: () => controller.updateFoodTypeToList(foodType),
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

  Widget _buildSelectedFoodType(int index, FoodType foodType, bool isLast) {
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
        if (isLast)
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                controller.removeFoodType(foodType);

                if (controller.selectedFoodTypes.isNotEmpty) {
                  controller.onRefresh(typeId: controller.selectedFoodTypes.last.typeId ?? '');
                } else {
                  controller.onRefresh();
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
