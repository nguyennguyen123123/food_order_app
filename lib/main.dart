import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/service/app_service.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/theme/app_theme_util.dart';
import 'package:food_delivery_app/theme/base_theme_data.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/reponsive/size_config.dart';
import 'package:get/get.dart';

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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food App',
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
  }
}
