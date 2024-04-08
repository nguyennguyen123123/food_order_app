// ignore_for_file: lines_longer_than_80_chars, prefer_null_aware_method_calls, public_member_api_docs

import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class LanguageWidgets extends StatelessWidget {
  const LanguageWidgets({
    required this.languageCode,
    required this.languageText,
    required this.countryCode,
    required this.locale,
    this.onLanguageTap,
    Key? key,
  });

  final String languageCode;
  final String countryCode;
  final String languageText;
  final VoidCallback? onLanguageTap;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onLanguageTap,
      child: Container(
        padding: padding(all: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: languageCode == locale ? appTheme.baseColor : appTheme.greyscale200Color,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16.w),
            Text(
              languageText,
              style: StyleThemeData.regular14(),
            ),
            const Spacer(),
            if (languageCode == locale) ...[
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
