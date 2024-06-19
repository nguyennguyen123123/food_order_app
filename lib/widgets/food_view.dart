import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/default_box_shadow.dart';
import 'package:food_delivery_app/widgets/dialog_view/add_food_dialog.dart';
import 'package:food_delivery_app/widgets/normal_quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class FoodView extends StatelessWidget {
  const FoodView({
    required this.foodModel,
    this.showAddBtn = false,
    Key? key,
    this.showChangeOnQuantity = false,
    this.quantity = 0,
    this.updateQuantity,
    this.onAdd,
  }) : super(key: key);

  final FoodModel foodModel;
  final bool showAddBtn;
  final VoidCallback? onAdd;
  final void Function(int)? updateQuantity;
  final bool showChangeOnQuantity;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: appTheme.whiteText,
        boxShadow: defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomNetworkImage(
            url: foodModel.image,
            height: 150,
            width: double.infinity,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                      Text(
                        foodModel.name ?? '',
                        style: StyleThemeData.regular16(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(Utils.getCurrency(foodModel.price), style: StyleThemeData.regular16()),
                    ],
                  ),
                ),
                if (showAddBtn && !showChangeOnQuantity)
                  GestureDetector(
                    onTap: onAdd ?? () => DialogUtils.showBTSView(AddFoodBTS(foodModel: foodModel)),
                    child: Icon(Icons.add),
                  ),
                if (showChangeOnQuantity) ...[
                  if (quantity > 0) ...[
                    NormalQuantityView(
                      showTitle: false,
                      updateQuantity: updateQuantity,
                      quantity: quantity,
                      canReduceToZero: true,
                    )
                  ] else ...[
                    GestureDetector(
                      onTap: onAdd ?? () => DialogUtils.showBTSView(AddFoodBTS(foodModel: foodModel)),
                      child: Icon(Icons.add),
                    ),
                  ]
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
