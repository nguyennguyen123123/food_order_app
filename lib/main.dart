import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:food_delivery_app/l10n/language_constants.dart';
import 'package:food_delivery_app/resourese/service/app_service.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/theme/app_theme_util.dart';
import 'package:food_delivery_app/theme/base_theme_data.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/reponsive/size_config.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppThemeUtil themeUtil = AppThemeUtil();
BaseThemeData get appTheme => themeUtil.getAppTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppService.initAppService();

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
  Locale _locale = const Locale("vi");
  final _localeStream = StreamController<Locale?>.broadcast();

  late StreamSubscription<Locale?> _localSubscription;

  @override
  void initState() {
    super.initState();
    _localSubscription = _localeStream.stream.listen((locale) {
      if (locale != null) {
        _locale = locale;
        setLocale(locale.languageCode, locale.countryCode ?? '');
      }
    });
    // _localeStream.add(_locale);
    getLocale().then((value) => _localeStream.add(value));
  }

  Locale get locale => _locale;

  set locale(Locale locale) {
    _localeStream.add(locale);
  }

  void handleLanguageChange(Locale locale) async {
    final pref = await SharedPreferences.getInstance();
    (pref.getString(LAGUAGE_CODE) ?? '').isNotEmpty;
    this.locale = locale;
  }

  @override
  void dispose() {
    themeUtil.dispose();
    _localSubscription.cancel();
    _localeStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _localeStream.stream,
      initialData: _locale,
      builder: (context, snapshot) {
        return GetMaterialApp(
          title: 'Food App',
          locale: _locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
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
        );
      },
    );
  }
}
