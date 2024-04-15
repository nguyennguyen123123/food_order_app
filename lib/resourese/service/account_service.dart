//handle account data in here

import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/service/printer_service.dart';
import 'package:food_delivery_app/resourese/service/storage_service.dart';
import 'package:get/get.dart';

class AccountService {
  final StorageService storageService;
  final IProfileRepository profileRepository;
  final PrinterService printerService;
  final BaseService baseService;
  final account = Rx<Account?>(null);

  Account? get myAccount => account.value;

  AccountService({
    required this.storageService,
    required this.baseService,
    required this.printerService,
    required this.profileRepository,
  });

  bool isLogin() {
    return baseService.client.auth.currentSession != null;
  }

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
    printerService.clear();
  }
}
