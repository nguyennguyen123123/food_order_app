import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    required this.controller,
    required this.hintText,
    this.iconData,
    this.colorSide,
    this.vertical = 16,
    this.horizontal = 16,
    this.colorHintText,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.suffixIcon,
    this.passCheck = false,
    this.obscure = true,
    this.focusedColor,
    this.colorText,
    this.focusNode,
    this.borderRadius,
    this.onFieldSubmitted,
    this.borderCircular = 50,
    this.cursorColor,
    this.inputFormatters,
    this.onTap,
    this.maxLines = 1,
    this.minLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? iconData;
  final FocusNode? focusNode;
  final Color? colorSide;
  final double vertical;
  final double horizontal;
  final Color? colorHintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool passCheck;
  final bool obscure;
  final Color? focusedColor;
  final Color? colorText;
  final double? borderRadius;
  final ValueChanged<String>? onFieldSubmitted;
  final double borderCircular;
  final Color? cursorColor;
  final List<TextInputFormatter>? inputFormatters;
  final GestureTapCallback? onTap;
  final int maxLines;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: passCheck == true ? obscure : false,
      style: StyleThemeData.styleSize14Weight500(color: colorText),
      cursorColor: cursorColor,
      inputFormatters: inputFormatters,
      onTap: onTap,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: StyleThemeData.styleSize14Weight500(color: colorHintText ?? appTheme.greyscale300Color),
        prefixIcon: iconData != null ? Icon(iconData, color: appTheme.greyscale400Color) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius ?? 50)),
        contentPadding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
          borderSide: BorderSide(color: colorSide ?? appTheme.greyscale200Color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
          borderSide: BorderSide(color: focusedColor ?? appTheme.blackColor),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
