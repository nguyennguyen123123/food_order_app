// ignore_for_file: lines_longer_than_80_chars, prefer_null_aware_method_calls, public_member_api_docs

import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/language/language_value.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class LanguageWidgets extends StatelessWidget {
  const LanguageWidgets({
    required this.languageCode,
    required this.languageIcon,
    required this.languageText,
    required this.languageValue,
    required this.groupValue,
    required this.flagCode,
    required this.countryCode,
    this.onLanguageTap,
    Key? key,
  });

  final String languageCode;
  final String countryCode;
  final String languageIcon;
  final String languageText;
  final Language languageValue;
  final String flagCode;
  final Language? groupValue;
  final void Function(String, String?, Language?)? onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onLanguageTap != null) {
          onLanguageTap!(languageCode, countryCode, languageValue);
        }
      },
      child: Container(
        padding: padding(all: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: languageValue == groupValue ? appTheme.baseColor : appTheme.greyscale200Color,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: padding(all: 20),
              decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.greyscale200Color),
              child: Text(languageIcon, style: const TextStyle(fontSize: 20)),
            ),
            SizedBox(width: 16.w),
            Text(
              languageText,
              style: StyleThemeData.regular14(),
            ),
            const Spacer(),
            if (languageValue == groupValue) ...[
              Container(
                height: 24.h,
                width: 24.w,
                decoration: BoxDecoration(color: appTheme.baseColor, shape: BoxShape.circle),
                child: Icon(Icons.check, size: 14, color: appTheme.whiteText),
              ),
            ] else ...[
              Container(
                height: 24.h,
                width: 24.w,
                decoration: BoxDecoration(
                  border: Border.all(color: appTheme.greyscale200Color),
                  shape: BoxShape.circle,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
