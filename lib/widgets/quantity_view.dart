import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class QuantityView extends StatefulWidget {
  const QuantityView({
    Key? key,
    this.updateQuantity,
    this.checkUpdateValue,
    this.canUpdate = true,
    this.quantity = 1,
    this.showTitle = true,
  }) : super(key: key);

  final int quantity;
  final void Function(int quantity)? updateQuantity;
  final bool canUpdate;
  final bool showTitle;
  final bool Function(int quantity)? checkUpdateValue;

  @override
  State<QuantityView> createState() => _QuantityViewState();
}

class _QuantityViewState extends State<QuantityView> {
  late final quantityNotifier = ValueNotifier(widget.quantity);

  @override
  void dispose() {
    quantityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.showTitle) Text("Số lượng", style: StyleThemeData.regular12()),
        SizedBox(width: 4.w),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: appTheme.borderColor),
          ),
          child: ValueListenableBuilder(
            valueListenable: quantityNotifier,
            builder: (context, quantity, child) => Row(
              children: [
                Opacity(
                  opacity: quantity == 1 ? 0.5 : 1,
                  child: GestureDetector(
                      onTap: () {
                        if (quantity == 1) return;
                        quantityNotifier.value -= 1;
                        widget.updateQuantity?.call(quantityNotifier.value);
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
                      final newQuantity = quantityNotifier.value + 1;
                      if (widget.checkUpdateValue?.call(newQuantity) ?? true) {
                        quantityNotifier.value = newQuantity;
                        widget.updateQuantity?.call(quantityNotifier.value);
                      }
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
