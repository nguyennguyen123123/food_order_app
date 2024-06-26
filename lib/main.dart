import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_delivery_app/constant/translations/localization_service.dart';
import 'package:food_delivery_app/resourese/service/app_service.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/theme/app_theme_util.dart';
import 'package:food_delivery_app/theme/base_theme_data.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/reponsive/size_config.dart';
import 'package:get/get.dart';

import 'utils/local_storage.dart';

AppThemeUtil themeUtil = AppThemeUtil();
BaseThemeData get appTheme => themeUtil.getAppTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppService.initAppService();
  await LocalStorage.init();

  runApp(LayoutBuilder(builder: (context, constraints) {
    SizeConfig.instance.init(constraints: constraints, screenHeight: 812, screenWidth: 375);

    return MyApp();
  }));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void dispose() {
    themeUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      locale: LocalizationService.locale,
      supportedLocales: LocalizationService.locales,
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        primarySwatch: MaterialColor(
          UniversalVariables.orangeColor.value,
          <int, Color>{
            50: UniversalVariables.orangeColor,
            100: UniversalVariables.orangeColor,
            200: UniversalVariables.orangeColor,
            300: UniversalVariables.orangeColor,
            400: UniversalVariables.orangeColor,
            500: UniversalVariables.orangeColor,
            600: UniversalVariables.orangeColor,
            700: UniversalVariables.orangeColor,
            800: UniversalVariables.orangeColor,
            900: UniversalVariables.orangeColor,
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
      builder: EasyLoading.init(),
    );
  }
}
