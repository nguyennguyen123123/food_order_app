// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Language { english, vietnamese }

Future<Language> getLocale() async {
  final prefs = await SharedPreferences.getInstance();

  final languageCode = prefs.getString('languageCode') ?? 'vi';

  if (languageCode == 'en') {
    return Language.english;
  } else if (languageCode == 'vi') {
    return Language.vietnamese;
  }

  return Language.vietnamese;
}

List<Map<String, Object>?> getLanguageListWithContext(BuildContext context) {
  final l10n = context.l10n;
  return supportedLocales
      .map((locale) {
        if (locale.languageCode == 'en') {
          return {
            'languageCode': 'en',
            'icon': '🇬🇧',
            'text': l10n.english_text,
            'value': Language.english,
            'flag_code': 'us',
          };
        } else if (locale.languageCode == 'vi') {
          return {
            'languageCode': 'vi',
            'icon': '🇻🇳',
            'text': l10n.vietnamese_text,
            'value': Language.vietnamese,
            'flag_code': 'vn',
          };
        }
        return null;
      })
      .where((element) => element != null)
      .toList();
}
