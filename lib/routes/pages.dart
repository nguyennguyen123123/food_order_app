import 'package:food_delivery_app/screen/admin/admin_binding.dart';
import 'package:food_delivery_app/screen/admin/admin_page.dart';
import 'package:food_delivery_app/screen/auth/sign_in_binding.dart';
import 'package:food_delivery_app/screen/auth/sign_in_screen.dart';
import 'package:food_delivery_app/screen/cart/cart_binding.dart';
import 'package:food_delivery_app/screen/cart/cart_page.dart';
import 'package:food_delivery_app/screen/food/food_binding.dart';
import 'package:food_delivery_app/screen/food/food_screen.dart';
import 'package:food_delivery_app/screen/food/view/add_type_food_view.dart';
import 'package:food_delivery_app/screen/food/view/create_edit_food_view.dart';
import 'package:food_delivery_app/screen/home/home_main.dart';
import 'package:food_delivery_app/screen/home/home_main_binding.dart';
import 'package:food_delivery_app/screen/language/language_screen.dart';
import 'package:food_delivery_app/screen/list_food/list_food_binding.dart';
import 'package:food_delivery_app/screen/list_food/list_food_page.dart';
import 'package:food_delivery_app/screen/onboarding/onboarding_scrreen.dart';
import 'package:food_delivery_app/screen/profile/view/my_account_view.dart';
import 'package:food_delivery_app/screen/splash/splash_binding.dart';
import 'package:food_delivery_app/screen/splash/splash_page.dart';
import 'package:food_delivery_app/screen/staff_manage/staff_manage_binding.dart';
import 'package:food_delivery_app/screen/staff_manage/staff_manage_page.dart';
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
      page: () => SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => HomeMain(),
      binding: HomeMainBinding(),
    ),
    GetPage(
      name: Routes.ADMIN,
      page: () => AdminPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.STAFF_MANAGE,
      page: () => StaffManagePage(),
      binding: StaffManageBinding(),
    ),
    GetPage(
      name: Routes.FOOD,
      page: () => FoodScreen(),
      binding: FoodBinding(),
    ),
    GetPage(
      name: Routes.ADDFOOD,
      page: () => CreateEditFoodView(),
      // binding: FoodBinding(),
    ),
    GetPage(
      name: Routes.ADDTYPEFOOD,
      page: () => AddTypeFoodView(),
      // binding: FoodBinding(),
    ),
    GetPage(
      name: Routes.LANGUAGE,
      page: () => LanguageScreen(),
    ),
    GetPage(
      name: Routes.LIST_FOOD,
      page: () => ListFoodPage(),
      binding: ListFoodBinding(),
    ),
    GetPage(
      name: Routes.CART,
      page: () => CartPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: Routes.MYACCOUNT,
      page: () => MyAccountView(),
    ),
  ];
}
