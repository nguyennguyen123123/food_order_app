import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/screen/cart/dialog/edit_reason_bottom_sheet.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/bottom_button.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/search/app_search_bar.dart';
import 'package:get/get.dart';

class OrderAddFoodBTS extends StatefulWidget {
  const OrderAddFoodBTS({Key? key}) : super(key: key);

  @override
  State<OrderAddFoodBTS> createState() => _OrderAddFoodBTSState();
}

class _OrderAddFoodBTSState extends State<OrderAddFoodBTS> {
  late final IFoodRepository foodRepository = Get.find();

  final foods = Rx<List<FoodModel>?>(null);
  final isCurrentFood = Rx<String?>(null);
  final isLoading = false.obs;
  String keyword = '';
  final searchNode = FocusNode();
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  void dispose() {
    foods.close();
    isCurrentFood.close();
    isLoading.close();
    searchNode.dispose();
    super.dispose();
  }

  void onSearch(String text) {
    keyword = text;
    onRefresh();
  }

  Future<void> onRefresh() async {
    isLoading.value = true;
    isCurrentFood.value = '';
    foods.value = await foodRepository.getListFoodByKeyword(keyword: keyword);
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSearchBar(
          onGetSearchValue: onSearch,
          focusNode: searchNode,
          getSearchStatus: (value) => isLoading.value = value,
        ),
        SizedBox(height: 8.h),
        Expanded(child: Obx(() {
          if (isLoading.value || foods.value == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.separated(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (context, index) => _buildFoodItem(index, foods.value![index]),
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemCount: foods.value?.length ?? 0);
          }
        })),
        Obx(
          () => BottomButton(
              isDisableConfirm: isCurrentFood.value?.isEmpty ?? true,
              onConfirm: () async {
                if ((isCurrentFood.value?.isNotEmpty ?? false) == true) {
                  final food = foods.value?.firstWhereOrNull((element) => element.foodId == isCurrentFood.value);
                  final result = await DialogUtils.showBTSView(EditReasonBottomSheet(), isWrap: true);
                  Get.back(
                      result: OrderItem(
                          food: food,
                          foodId: food?.foodId,
                          quantity: quantity,
                          note: result != null ? result as String? ?? '' : ''));
                }
              }),
        )
      ],
    );
  }

  Widget _buildFoodItem(int index, FoodModel foodModel) {
    return Obx(() {
      final isCurrent = isCurrentFood.value == foodModel.foodId;
      void onUpdateCurrentFood(bool res) {
        searchNode.unfocus();
        if (res) {
          quantity = 1;
          isCurrentFood.value = foodModel.foodId;
        } else {
          isCurrentFood.value = '';
        }
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onUpdateCurrentFood(isCurrent),
        child: Row(
          children: [
            Checkbox(value: isCurrent, onChanged: (value) => onUpdateCurrentFood(value ?? true)),
            CustomNetworkImage(url: foodModel.image, size: 80, borderRadius: BorderRadius.circular(8)),
            SizedBox(width: 8.w),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(foodModel.name ?? '', style: StyleThemeData.bold16()),
                if (isCurrent) ...[QuantityView(updateQuantity: (quantity) => this.quantity = quantity)]
              ],
            ))
          ],
        ),
      );
    });
  }
}
