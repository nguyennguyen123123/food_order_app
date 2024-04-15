import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/food/edit_food/edit_food_parameter.dart';
import 'package:food_delivery_app/screen/food/food_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';

class FoodScreen extends GetWidget<FoodController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.transparentColor,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          // actions: [
          //   IconButton(
          //     onPressed: () => controller.addRandomFood(),
          //     icon: Icon(Icons.ad_units, color: appTheme.blackColor),
          //   ),
          // ],
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: appTheme.blackColor),
              ),
              Text('create_menu'.tr, style: StyleThemeData.bold18(height: 0)),
            ],
          ),
        ),
        body: Obx(
          () => Padding(
            padding: padding(all: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.ADDTYPEFOOD);
                      },
                      child: Container(
                        padding: padding(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.appColor),
                        ),
                        child: Text('add_category'.tr, style: StyleThemeData.regular14(height: 0)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.ADDFOOD);
                      },
                      child: Container(
                        padding: padding(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.appColor),
                        ),
                        child: Text('add_item'.tr, style: StyleThemeData.regular14(height: 0)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 90.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.foodTypeList.length,
                    itemBuilder: (context, index) {
                      FoodType foodType = controller.foodTypeList[index];
                      return Container(
                        margin: EdgeInsets.all(8),
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: NetworkImage(foodType.image ?? '')),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => controller.foodList.value == null
                        ? Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: controller.onRefresh,
                            child: LoadMore(
                              delegate: LoadMoreDelegateCustom(),
                              onLoadMore: controller.onLoadMoreFood,
                              child: ListView.separated(
                                itemCount: controller.foodList.value!.length,
                                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                                itemBuilder: (context, index) => itemFoodList(index, controller.foodList.value![index]),
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

  Widget itemFoodList(int index, FoodModel food) {
    return Container(
      height: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: food.image ?? '',
                  fit: BoxFit.cover,
                  width: 120.w,
                  height: 120.h,
                  errorWidget: (context, url, error) {
                    return Image.asset('assets/logo.jpg');
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'name'.tr + ': ${food.name}',
                      style: StyleThemeData.bold18(),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'description'.tr + ': ${food.description}',
                      style: StyleThemeData.regular14(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('price'.tr + ': ${Utils.getCurrency(food.price)}', style: StyleThemeData.regular16()),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Flexible(
                child: InkWell(
                  onTap: () async {
                    final result = await DialogUtils.showYesNoDialog(
                      title: 'are_you_sure_you_want_to_delete_this_dish'.tr,
                    );
                    if (result == true) {
                      controller.deleteFood(food.foodId.toString(), index);
                    }
                  },
                  child: Container(
                    width: Get.width.w,
                    height: 32.h,
                    alignment: Alignment.center,
                    padding: padding(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: appTheme.errorColor),
                    ),
                    child: Text('delete'.tr, style: StyleThemeData.regular14(height: 0)),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.EDITFOOD, arguments: EditFoodParameter(foodModel: food)),
                  child: Container(
                    width: Get.width.w,
                    height: 32.h,
                    alignment: Alignment.center,
                    padding: padding(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appTheme.appColor,
                    ),
                    child: Text(
                      'edit'.tr,
                      style: StyleThemeData.regular14(color: appTheme.whiteText, height: 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
