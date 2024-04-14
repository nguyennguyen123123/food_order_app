import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/custom_network_image.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/quantity_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AddItemPartyDialog extends StatefulWidget {
  const AddItemPartyDialog({Key? key}) : super(key: key);

  @override
  State<AddItemPartyDialog> createState() => _AddItemPartyDialogState();
}

class _AddItemPartyDialogState extends State<AddItemPartyDialog> {
  late final OrderCartService cartService = Get.find();

  final indexSelected = <int>[];
  final partyItems = ValueNotifier<List<OrderItem>>([]);

  @override
  void dispose() {
    partyItems.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400.h,
        width: 650.w,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: padding(right: 12, top: 4),
                child: GestureDetector(
                  onTap: Get.back,
                  child: Container(
                      padding: padding(all: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.background700Color,
                      ),
                      child: Icon(Icons.close, size: 18.w)),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: ValueListenableBuilder<List<OrderItem>>(
                valueListenable: partyItems,
                builder: (context, items, child) => ListView.separated(
                  padding: padding(all: 12),
                  itemCount: cartService.items.value.length,
                  separatorBuilder: (context, index) => SizedBox(height: 4.h),
                  itemBuilder: (context, index) => _buildOrderItem(index, cartService.items.value[index], items),
                ),
              ),
            ),
            Padding(
              padding: padding(all: 4),
              child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                    onPressed: Get.back,
                    child: Text('cancel'.tr, style: StyleThemeData.bold18()),
                  )),
                  SizedBox(width: 6.w),
                  Expanded(
                      child: PrimaryButton(
                    onPressed: () => Get.back(result: partyItems.value),
                    contentPadding: padding(vertical: 8),
                    radius: BorderRadius.circular(1000),
                    borderColor: appTheme.primaryColor,
                    backgroundColor: appTheme.primaryColor,
                    child: Text('confirm'.tr, style: StyleThemeData.bold18(color: appTheme.whiteText)),
                  ))
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildOrderItem(int index, OrderItem orderItem, List<OrderItem> items) {
    final quantity = orderItem.quantity;
    final food = orderItem.food;

    final isSelected = indexSelected.contains(index);
    return Row(
      children: [
        Checkbox(
            value: isSelected,
            onChanged: (value) {
              final list = [...items];
              if (indexSelected.contains(index)) {
                indexSelected.remove(index);

                list.removeWhere((ele) => ele.foodId == food?.foodId);
              } else {
                indexSelected.add(index);
                list.add(orderItem.copyWith(orignalQuantity: orderItem.quantity));
              }
              partyItems.value = list;
            }),
        CustomNetworkImage(
          url: food?.image,
          size: 50,
          borderRadius: BorderRadius.circular(8),
        ),
        SizedBox(width: 4.w),
        Expanded(
            child: Text(
          food?.name ?? '',
          style: StyleThemeData.bold14(),
        )),
        if (isSelected)
          QuantityView(
            checkUpdateValue: (newQuantity) => newQuantity <= orderItem.quantity,
            updateQuantity: (quantity) {
              final index = partyItems.value.indexWhere((element) => element.foodId == food?.foodId);
              partyItems.value[index].quantity = quantity;
            },
          ),
      ],
    );
  }
}
