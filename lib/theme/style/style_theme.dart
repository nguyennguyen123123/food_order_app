import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class StyleThemeData {
  static TextStyle regular10({Color? color}) => TextStyle(
        fontSize: 10.fontSize,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: 1.5.h,
      );

  static TextStyle bold10({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 10.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: height.h,
      );

  static TextStyle bold17({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 17.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: height.h,
      );

  static TextStyle bold11({BuildContext? context, Color? color}) => TextStyle(
        fontSize: 11.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5.h,
        letterSpacing: -0.2,
      );

  static TextStyle regular12({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 12.fontSize,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: height.h,
      );

  static TextStyle bold12({Color? color}) => TextStyle(
        fontSize: 12.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5.h,
      );

  static TextStyle regular13({Color? color}) => TextStyle(
        fontSize: 13.fontSize,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: 1.5.h,
      );

  static TextStyle bold13({Color? color}) => TextStyle(
        fontSize: 13.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5.h,
      );

  static TextStyle regular14({Color? color, double height = 1.5}) => TextStyle(
        fontSize: 14.fontSize,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: height.h,
      );

  static TextStyle bold14({Color? color, double height = 1.5}) => TextStyle(
        fontSize: 14.fontSize,
        fontWeight: FontWeight.w500,
        color: color ?? appTheme.blackColor,
        height: height.h,
      );

  static TextStyle regular16({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 16.fontSize,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: height.h,
        letterSpacing: 0.2,
      );

  static TextStyle regular17({BuildContext? context, Color? color}) => TextStyle(
        fontSize: 17.fontSize,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
      );

  static TextStyle bold16({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 16.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: height.h,
      );

  static TextStyle bold18({Color? color, double height = 1.5}) => TextStyle(
        fontSize: 16.fontSize,
        fontWeight: FontWeight.w600,
        color: color ?? appTheme.blackColor,
        height: height.h,
      );

  static TextStyle bold24({Color? color, double height=1.5}) => TextStyle(
        fontSize: 24.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: height.h,
      );

  static TextStyle bold28({Color? color}) => TextStyle(
        fontSize: 28.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5.h,
      );

  static TextStyle bold30({Color? color}) => TextStyle(
        fontSize: 30.fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5.h,
      );
}
