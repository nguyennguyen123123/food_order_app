import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';

class StyleThemeData {
  static TextStyle styleSize10Weight400({Color? color}) => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize10Weight600({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color ?? appTheme.blackColor,
        height: height,
      );

  static TextStyle styleSize11Weight600({BuildContext? context, Color? color}) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color ?? appTheme.blackColor,
        height: 1.5,
        letterSpacing: -0.2,
      );

  static TextStyle styleSize12Weight400({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: height,
      );

  static TextStyle styleSize12Weight500({BuildContext? context, Color? color}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize12Weight600({BuildContext? context, Color? color}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize12Weight700({Color? color}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize14Weight400({Color? color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize14Weight500({Color? color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize14Weight600({Color? color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );
  static TextStyle styleSize14Weight700({Color? color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize16Weight400({BuildContext? context, Color? color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? appTheme.blackColor,
        height: 1.5,
        letterSpacing: 0.2,
      );

  static TextStyle styleSize16Weight600({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? appTheme.blackColor,
        height: height,
      );

  static TextStyle styleSize16Weight700({BuildContext? context, Color? color, double height = 1.5}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: height,
      );

  static TextStyle styleSize18Weight600({Color? color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize24Weight700({Color? color}) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );

  static TextStyle styleSize28Weight700({Color? color}) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color ?? appTheme.blackColor,
        height: 1.5,
      );
}
