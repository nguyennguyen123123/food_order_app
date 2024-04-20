import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class NormalQuantityView extends StatelessWidget {
  const NormalQuantityView({
    Key? key,
    this.updateQuantity,
    this.checkUpdateValue,
    this.canUpdate = true,
    this.quantity = 1,
    this.showTitle = true,
    this.canReduceToZero = false,
  }) : super(key: key);

  final int quantity;
  final void Function(int quantity)? updateQuantity;
  final bool canUpdate;
  final bool showTitle;
  final bool Function(int quantity)? checkUpdateValue;
  final bool canReduceToZero;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showTitle) Text("Số lượng", style: StyleThemeData.regular12()),
        SizedBox(width: 4.w),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: appTheme.borderColor),
          ),
          child: Row(
            children: [
              Opacity(
                opacity: quantity == 1 && !canReduceToZero ? 0.5 : 1,
                child: GestureDetector(
                    onTap: () {
                      if (quantity == 1 && !canReduceToZero) return;
                      updateQuantity?.call(quantity - 1);
                    },
                    child: Icon(Icons.remove)),
              ),
              Container(
                width: 1.w,
                height: 12.h,
                color: appTheme.borderColor,
              ),
              Padding(
                  padding: padding(horizontal: 6), child: Text(quantity.toString(), style: StyleThemeData.bold12())),
              Container(
                width: 1.w,
                height: 12.h,
                color: appTheme.borderColor,
              ),
              GestureDetector(
                  onTap: () {
                    final newQuantity = quantity + 1;
                    if (checkUpdateValue?.call(newQuantity) ?? true) {
                      updateQuantity?.call(newQuantity);
                    }
                  },
                  child: Icon(Icons.add)),
            ],
          ),
        ),
      ],
    );
  }
}
