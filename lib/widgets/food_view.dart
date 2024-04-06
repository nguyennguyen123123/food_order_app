import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class FoodView extends StatelessWidget {
  const FoodView({required this.foodModel, this.showAddBtn = false, this.onAdd, Key? key}) : super(key: key);

  final FoodModel foodModel;
  final bool showAddBtn;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: appTheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomNetworkImage(
            url: foodModel.image,
            height: 150,
            width: double.infinity,
            radius: 12,
          ),
          SizedBox(height: 12.h),
          Padding(
              padding: padding(horizontal: 12, bottom: 12, top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(foodModel.name ?? '', style: StyleThemeData.regular16()),
                        SizedBox(height: 2.h),
                        Text(Utils.getCurrency(foodModel.price), style: StyleThemeData.regular16()),
                      ],
                    ),
                  ),
                  if (showAddBtn) GestureDetector(onTap: onAdd, child: Icon(Icons.add))
                ],
              )),
        ],
      ),
    );
  }
}
