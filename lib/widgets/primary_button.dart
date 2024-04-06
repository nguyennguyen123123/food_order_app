import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.radius,
      this.borderColor,
      this.backgroundColor,
      this.contentPadding})
      : super(key: key);
  final Function() onPressed;
  final Widget child;
  final BorderRadiusGeometry? radius;
  final Color? borderColor;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: onPressed,
        child: child,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: Size.zero,
          padding: contentPadding ?? EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: radius ?? BorderRadius.circular(4),
              side: BorderSide(color: borderColor ?? appTheme.primaryColor)),
        ));
  }
}
