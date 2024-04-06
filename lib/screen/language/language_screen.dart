import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/language/language_value.dart';
import 'package:food_delivery_app/screen/language/language_widgets.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final languageNotifier = ValueNotifier<Language>(Language.english);
  late Map<String, dynamic>? language;
  late Language currentLanguage;

  @override
  void initState() {
    super.initState();
    getLocale().then((value) {
      currentLanguage = value;
      languageNotifier.value = value;
    });
  }

  @override
  void dispose() {
    languageNotifier.dispose();
    super.dispose();
  }

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
        child: ValueListenableBuilder<Language>(
          valueListenable: languageNotifier,
          builder: (context, value, child) =>
              child ??
              ListView(
                padding: padding(bottom: 5),
                children: getLanguageListWithContext(context).map((language) {
                  return language == null
                      ? const SizedBox()
                      : Padding(
                          padding: padding(top: language['languageCode'] != 'vi' ? 16 : 0),
                          child: LanguageWidgets(
                            flagCode: language['flag_code'].toString(),
                            languageCode: language['languageCode'].toString(),
                            countryCode: language['countryCode'] as String? ?? '',
                            languageIcon: language['icon'].toString(),
                            languageText: language['text'].toString(),
                            languageValue: language['value'] as Language,
                            onLanguageTap: (languageCode, countryCode, lang) {
                              this.language = language;
                              // if (countryCode != null) {
                              //   someFunction(context, Locale(languageCode, countryCode));
                              // } else {
                              //   someFunction(context, Locale(languageCode));
                              // }
                              Navigator.pop(context);
                              if (lang != null) {
                                languageNotifier.value = lang;
                              }
                            },
                            groupValue: value,
                          ),
                        );
                }).toList(),
              ),
        ),
      ),
    );
  }
}
