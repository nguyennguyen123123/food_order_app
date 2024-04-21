import 'package:food_delivery_app/screen/admin/admin_binding.dart';
import 'package:food_delivery_app/screen/admin/admin_page.dart';
import 'package:food_delivery_app/screen/area/area_binding.dart';
import 'package:food_delivery_app/screen/area/area_pages.dart';
import 'package:food_delivery_app/screen/area/edit/edit_area_binding.dart';
import 'package:food_delivery_app/screen/area/view/add_area_view.dart';
import 'package:food_delivery_app/screen/area/view/edit_area_view.dart';
import 'package:food_delivery_app/screen/auth/sign_in_binding.dart';
import 'package:food_delivery_app/screen/auth/sign_in_screen.dart';
import 'package:food_delivery_app/screen/cart/cart_binding.dart';
import 'package:food_delivery_app/screen/cart/cart_page.dart';
import 'package:food_delivery_app/screen/check_in_out/check_in_out_binding.dart';
import 'package:food_delivery_app/screen/check_in_out/check_in_out_pages.dart';
import 'package:food_delivery_app/screen/food/edit_food/edit_food_binding.dart';
import 'package:food_delivery_app/screen/food/edit_food/edit_food_view.dart';
import 'package:food_delivery_app/screen/food/food_binding.dart';
import 'package:food_delivery_app/screen/food/food_screen.dart';
import 'package:food_delivery_app/screen/food/view/add_food_view.dart';
import 'package:food_delivery_app/screen/food/view/add_type_food_view.dart';
import 'package:food_delivery_app/screen/food_order_manage/food_order_manage_binding.dart';
import 'package:food_delivery_app/screen/food_order_manage/food_order_manage_page.dart';
import 'package:food_delivery_app/screen/history_order/history_order_binding.dart';
import 'package:food_delivery_app/screen/history_order/history_order_page.dart';
import 'package:food_delivery_app/screen/home/home_main.dart';
import 'package:food_delivery_app/screen/home/home_main_binding.dart';
import 'package:food_delivery_app/screen/language/language_screen.dart';
import 'package:food_delivery_app/screen/list_food/list_food_binding.dart';
import 'package:food_delivery_app/screen/list_food/list_food_page.dart';
import 'package:food_delivery_app/screen/onboarding/onboarding_scrreen.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_binding.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_page.dart';
import 'package:food_delivery_app/screen/order_detail/view/order_detail_binding.dart';
import 'package:food_delivery_app/screen/order_detail/view/order_detail_page.dart';
import 'package:food_delivery_app/screen/printer/edit/edit_printer_binding.dart';
import 'package:food_delivery_app/screen/printer/printe_pages.dart';
import 'package:food_delivery_app/screen/printer/printer_binding.dart';
import 'package:food_delivery_app/screen/printer/view/add_printer_view.dart';
import 'package:food_delivery_app/screen/printer/view/edit_printer_view.dart';
import 'package:food_delivery_app/screen/product/product_details_binding.dart';
import 'package:food_delivery_app/screen/product/product_details_screen.dart';
import 'package:food_delivery_app/screen/profile/view/my_account_view.dart';
import 'package:food_delivery_app/screen/splash/splash_binding.dart';
import 'package:food_delivery_app/screen/splash/splash_page.dart';
import 'package:food_delivery_app/screen/staff_manage/staff_manage_binding.dart';
import 'package:food_delivery_app/screen/staff_manage/staff_manage_page.dart';
import 'package:food_delivery_app/screen/table/edit/edit_table_binding.dart';
import 'package:food_delivery_app/screen/table/manage/table_manage_binding.dart';
import 'package:food_delivery_app/screen/table/table_binding.dart';
import 'package:food_delivery_app/screen/table/table_page.dart';
import 'package:food_delivery_app/screen/table/view/add_table_view.dart';
import 'package:food_delivery_app/screen/table/view/edit_table_view.dart';
import 'package:food_delivery_app/screen/type_details/type_details_binding.dart';
import 'package:food_delivery_app/screen/type_details/type_details_pages.dart';
import 'package:food_delivery_app/screen/voucher/edit/edit_voucher_binding.dart';
import 'package:food_delivery_app/screen/voucher/view/add_voucher_view.dart';
import 'package:food_delivery_app/screen/voucher/view/edit_voucher_view.dart';
import 'package:food_delivery_app/screen/voucher/voucher_binding.dart';
import 'package:food_delivery_app/screen/voucher/voucher_pages.dart';
import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_binding.dart';
import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_page.dart';
import 'package:get/get.dart';

import '../screen/table/manage/table_manage_page.dart';

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
      page: () => AddFoodView(),
      // binding: FoodBinding(),
    ),
    GetPage(
      name: Routes.EDITFOOD,
      page: () => EditFoodView(),
      binding: EditFoodBinding(),
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
    GetPage(
      name: Routes.PRINT,
      page: () => PrinterPages(),
      binding: PrinterBinding(),
    ),
    GetPage(
      name: Routes.ADDPRINTER,
      page: () => AddPrinterView(),
    ),
    GetPage(
      name: Routes.EDITPRINTER,
      page: () => EditPrinterView(),
      binding: EditPrinterBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_ORDER,
      page: () => FoodOrderManagePage(),
      binding: FoodOrderManageBinding(),
    ),
    GetPage(
      name: Routes.ORDER_DETAIL,
      page: () => OrderDetailPage(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: Routes.TABLEMANAGE,
      page: () => TableManagePage(),
      binding: TableManageBinding(),
    ),
    GetPage(
      name: Routes.TABLE,
      page: () => TablePage(),
      binding: TableBinding(),
    ),
    GetPage(
      name: Routes.ADDTABLE,
      page: () => AddTableView(),
    ),
    GetPage(
      name: Routes.EDITTABLE,
      page: () => EditTableView(),
      binding: EditTableBinding(),
    ),
    GetPage(
      name: Routes.VOUCHER,
      page: () => VoucherPages(),
      binding: VoucherBinding(),
    ),
    GetPage(
      name: Routes.ADDVOUCHER,
      page: () => AddVoucherView(),
    ),
    GetPage(
      name: Routes.EDITVOUCHER,
      page: () => EditVoucherView(),
      binding: EditVoucherBinding(),
    ),
    GetPage(
      name: Routes.CHECKINOUT,
      page: () => CheckInOutPages(),
      binding: CheckInOutBinding(),
    ),
    GetPage(
      name: Routes.HISTORY_ORDER,
      page: () => HistoryOrderPage(),
      binding: HistoryOrderBinding(),
    ),
    GetPage(
      name: Routes.PRODUCTDETAILS,
      page: () => ProductDetailsScreen(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: Routes.TYPEDETAIL,
      page: () => TypeDetailsPages(),
      binding: TypeDetailsBinding(),
    ),
    GetPage(
      name: Routes.WAITER_CART,
      page: () => WaiterCartPage(),
      binding: WaiterCartBinding(),
    ),
    GetPage(
      name: Routes.EDIT_ORDER,
      page: () => EditOrderDetailPage(),
      binding: EditOrderDetailBinding(),
    ),
    GetPage(
      name: Routes.AREA,
      page: () => AreaPages(),
      binding: AreaBinding(),
    ),
    GetPage(
      name: Routes.ADDAREA,
      page: () => AddAreaView(),
    ),
    GetPage(
      name: Routes.EDITAREA,
      page: () => EditAreaView(),
      binding: EditAreaBinding(),
    ),
  ];
}
