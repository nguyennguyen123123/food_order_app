//handle account data in here

import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/service/storage_service.dart';

class AccountService {
  final StorageService storageService;
  final BaseService baseService;

  AccountService({
    required this.storageService,
    required this.baseService,
  });

  bool isLogin() {
    return baseService.client.auth.currentSession != null;
  }
}
