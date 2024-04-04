//handle account data in here

import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/service/storage_service.dart';
import 'package:get/get.dart';

class AccountService {
  final StorageService storageService;
  final BaseService baseService;
  final account = Rx<Account?>(null);

  Account? get myAccount => account.value;

  AccountService({
    required this.storageService,
    required this.baseService,
  });

  bool isLogin() {
    return baseService.client.auth.currentSession != null;
  }
}
