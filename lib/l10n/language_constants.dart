// ignore_for_file: no_leading_underscores_for_local_identifiers, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';
const String COUNTRY_CODE = 'countryCode';

const String ENGLISH = 'en';
const String VIETNAMESE = 'vi';

Future<Locale> setLocale(String languageCode, String countryCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  await _prefs.setString(COUNTRY_CODE, countryCode.toLowerCase());
  return _locale(languageCode, countryCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "vi";
  String countryCode = _prefs.getString(COUNTRY_CODE) ?? '';
  return _locale(languageCode, countryCode);
}

Locale _locale(String languageCode, String countryCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case VIETNAMESE:
      return const Locale(VIETNAMESE, "VN");

    default:
      return const Locale(ENGLISH, 'US');
  }
}
