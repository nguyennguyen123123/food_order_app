import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/translations/localization_service.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/language/language_widgets.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final locales = [
    {'name': 'English', 'locale': 'en'},
    {'name': 'Vietnamese', 'locale': 'vi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: padding(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: appTheme.blackColor),
              ),
              SizedBox(width: 8.w),
              Text('Ngôn ngữ', style: StyleThemeData.bold14(height: 0)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: padding(all: 16),
        child: ListView.builder(
          itemCount: locales.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) => Padding(
            padding: padding(bottom: 16),
            child: LanguageWidgets(
              languageCode: LocalizationService.locale.languageCode,
              languageText: locales[index]['name'].toString(),
              countryCode: LocalizationService.locale.languageCode,
              locale: locales[index]['locale'].toString(),
              onLanguageTap: () {
                String _selectedLang = LocalizationService.locale.languageCode;
                _selectedLang = locales[index]['locale'].toString();
                LocalizationService.changeLocale(_selectedLang);
                Get.updateLocale(LocalizationService.locale);
                Get.back();
              },
            ),
          ),
        ),
      ),
    );
  }
}
