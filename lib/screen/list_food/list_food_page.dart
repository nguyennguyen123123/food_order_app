import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/screen/list_food/list_food_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/icons_assets.dart';
import 'package:food_delivery_app/widgets/food_view.dart';
import 'package:food_delivery_app/widgets/list_vertical_item.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/search/app_search_bar.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';

class ListFoodPage extends GetWidget<ListFoodController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("list_of_dishes".tr, style: StyleThemeData.bold18()), centerTitle: true),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: padding(all: 12),
              child: AppSearchBar(
                onGetSearchValue: (keyword) => controller.updateKeyword(keyword),
                getSearchStatus: controller.updateSearchStatus,
                hintText: 'search'.tr,
                leading: IconButton(
                  onPressed: null,
                  icon: SvgPicture.asset(IconAssets.searchIcon, width: 18.w, height: 18.h),
                ),
              ),
            ),
            Expanded(
              child: controller.isSeaching.value
                  ? Center(child: CircularProgressIndicator())
                  : LoadMore(
                      delegate: LoadMoreDelegateCustom(),
                      onLoadMore: controller.onLoadMore,
                      child: controller.foods.value == null
                          ? Center(child: CircularProgressIndicator())
                          : ListVerticalItem<FoodModel>(
                              items: controller.foods.value!,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (index, item) => Padding(
                                padding: padding(vertical: 12),
                                child: FoodView(foodModel: item, showAddBtn: true),
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
