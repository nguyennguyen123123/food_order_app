import 'package:food_delivery_app/screen/auth/sign_in_screen.dart';
import 'package:food_delivery_app/screen/onboarding/onboarding_scrreen.dart';
import 'package:get/get.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.ONBOARD,
      page: () => OnboardingScreen(),
    ),
    GetPage(
      name: Routes.SIGNIN,
      page: () => const SignInScreen(),
    ),
  ];
}
