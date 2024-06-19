import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AddFoodBTS extends StatefulWidget {
  const AddFoodBTS({required this.foodModel, Key? key}) : super(key: key);

  final FoodModel foodModel;

  @override
  State<AddFoodBTS> createState() => _AddFoodBTSState();
}

class _AddFoodBTSState extends State<AddFoodBTS> {
  final noteController = TextEditingController();
  var quantity = 1;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.foodModel;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        children: [
          Center(child: Text("add_food".tr, style: StyleThemeData.bold16())),
          SizedBox(height: 12.h),
          Center(
            child: CustomNetworkImage(
              url: food.image,
              width: 250,
              height: 250,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name ?? '', style: StyleThemeData.bold14()),
                    SizedBox(height: 8.h),
                    Text(food.description ?? '', style: StyleThemeData.regular16()),
                  ],
                ),
              ),
              QuantityView(updateQuantity: (quantity) => this.quantity = quantity)
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text("food_type".tr + ":", style: StyleThemeData.bold14()),
              SizedBox(width: 4.w),
              Text(food.foodType?.name ?? '', style: StyleThemeData.bold14())
            ],
          ),
          SizedBox(height: 12.h),
          EditTextFieldCustom(
              label: "note".tr,
              controller: noteController,
              hintText: "enter_note".tr,
              textInputAction: TextInputAction.done),
          SizedBox(height: 12.h),
          PrimaryButton(
            onPressed: () {
              // final cart = Get.find<OrderCartService>();
              // cart.onAddOrderItem(
              //     OrderItem(note: noteController.text, food: food, foodId: food.foodId, quantity: quantity));
              Get.back();
            },
            borderColor: appTheme.primaryColor,
            contentPadding: padding(all: 12),
            radius: BorderRadius.circular(100),
            backgroundColor: appTheme.primaryColor,
            child: Text('confirm'.tr, style: StyleThemeData.bold14(color: appTheme.whiteText)),
          )
        ],
      ),
    );
  }
}
