//handle account data in here

import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/resourese/service/printer_service.dart';
import 'package:food_delivery_app/resourese/service/storage_service.dart';
import 'package:get/get.dart';

class AccountService {
  final StorageService storageService;
  final IProfileRepository profileRepository;
  final PrinterService printerService;
  final BaseService baseService;
  final OrderCartService cartService;
  final account = Rx<Account?>(null);

  Account? get myAccount => account.value;

  AccountService({
    required this.storageService,
    required this.baseService,
    required this.printerService,
    required this.profileRepository,
    required this.cartService,
  });

  bool isLogin() {
    return baseService.client.auth.currentSession != null;
  }

  bool get isAdmin => myAccount?.role == USER_ROLE.ADMIN;

  bool get hasCheckIn => myAccount?.checkInTime != null;

  Future<void> initAccount() async {
    account.value = await profileRepository.getProfile();
    await printerService.init();
  }

  Future<void> login(Account account) async {
    this.account.value = account;
    await printerService.init();
  }

  Future<void> signOut() async {
    await profileRepository.signOut();
    cartService.clearCart();
    printerService.clear();
  }

  Future<void> onUpdateTotalPriceInAccount(double price) async {
    final newAccount = await profileRepository.updateTotalPriceInWorkingTime(myAccount?.userId ?? '', price);
    if (newAccount != null) {
      account.value = newAccount;
    }
  }
}
