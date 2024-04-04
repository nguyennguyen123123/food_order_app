import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/theme/app_theme_util.dart';
import 'package:food_delivery_app/theme/base_theme_data.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

const supabaseUrl = 'https://qsqxamitksgogcwasibq.supabase.co';
const supabaseKey = String.fromEnvironment(
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzcXhhbWl0a3Nnb2djd2FzaWJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4OTI0ODYsImV4cCI6MjAyMDQ2ODQ4Nn0.Qo0iZwQkAGG4DPL1O1BoYxn-ULTxlE1Ii8fkdgclJbg',
);

AppThemeUtil themeUtil = AppThemeUtil();
BaseThemeData get appTheme => themeUtil.getAppTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await supabase.Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final AuthMethods _authMethods = AuthMethods();
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
      initialRoute: Routes.ONBOARD,
      getPages: AppPages.pages,
      // home: StreamBuilder<User?>(
      //   stream: _authMethods.onAuthStateChanged,
      //   builder: (context, AsyncSnapshot<User?> snapshot) {
      //     if (snapshot.hasData && snapshot.data != null) {
      //       return HomePage();
      //     } else {
      //       return LoginPage();
      //     }
      //   },
      // ),
    );
  }
}
