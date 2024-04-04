//handle account data in here

import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/service/storage_service.dart';

class AccountService {
  final StorageService storageService;
  final ServerService serverService;

  AccountService({
    required this.storageService,
    required this.serverService,
  });

  bool isLogin() {
    return serverService.supabaseClient.auth.currentSession != null;
  }
}
