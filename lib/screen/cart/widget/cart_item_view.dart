import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/screen/cart/dialog/edit_reason_bottom_sheet.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/images_asset.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/image_asset_custom.dart';
import 'package:food_delivery_app/widgets/normal_quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class CartItemView extends StatelessWidget {
  const CartItemView(
    this.orderItem, {
    Key? key,
    required this.removeCartItem,
    required this.updateNote,
    required this.updateQuantity,
    this.showPartyIndex = false,
  });

  final OrderItem orderItem;
  final Function(int quantity) updateQuantity;
  final Function() removeCartItem;
  final Function(String note) updateNote;
  final bool showPartyIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomNetworkImage(url: orderItem.food?.image, size: 100),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderItem.food?.name ?? '', style: StyleThemeData.regular16()),
              Text("type".tr + (orderItem.food?.foodType?.name ?? '')),
              Text('price'.tr + ' ' + Utils.getCurrency(orderItem.food?.price ?? 0)),
              Text('note_text'.tr + (orderItem.note ?? '')),
              if (showPartyIndex)
                Row(
                  children: [
                    NormalQuantityView(
                      quantity: orderItem.quantity,
                      updateQuantity: (value) => updateQuantity(value),
                    ),
                    SizedBox(width: 4.w),
                    Text('Party ${orderItem.partyIndex + 1}'),
                  ],
                )
              else
                NormalQuantityView(
                  quantity: orderItem.quantity,
                  updateQuantity: (value) => updateQuantity(value),
                )
            ],
          ),
        ),
        Column(
          children: [
            GestureDetector(
                onTap: () async {
                  final result = await DialogUtils.showYesNoDialog(
                    title: 'do_you_want_to_remove_this_dish_from_the_order'.tr + '?',
                  );
                  if (result == true) {
                    removeCartItem();
                  }
                },
                child: ImageAssetCustom(imagePath: ImagesAssets.trash, size: 30)),
            SizedBox(height: 8.h),
            GestureDetector(
                onTap: () async {
                  final result =
                      await DialogUtils.showBTSView(EditReasonBottomSheet(reason: orderItem.note ?? ''), isWrap: true);
                  if (result != null && result is String) {
                    updateNote(result);
                  }
                },
                child: Icon(Icons.edit)),
          ],
        )
      ],
    );
  }
}
