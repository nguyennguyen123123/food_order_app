import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/screen/cart/cart_page.dart';
import 'package:food_delivery_app/screen/home/home_page.dart';
import 'package:food_delivery_app/screen/profile/profile_screen.dart';
import 'package:food_delivery_app/screen/table/table_page.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final OrderCartService cartService;

  MainController({required this.cartService});

  late PageController pageController;

  RxInt currentPage = 0.obs;

  List<Widget> pages = [
    HomePage(),
    CartPage(),
    TablePage(),
    ProfileScreen(),
  ];

  void switchTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
  }

  void goToTab(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void animateToTab(int page) {
    currentPage.value = page;
    pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
