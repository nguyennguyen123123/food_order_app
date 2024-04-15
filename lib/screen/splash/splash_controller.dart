import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final BaseService baseService;
  final IAuthRepository authRepository;
  final AccountService accountService;

  SplashController({
    required this.baseService,
    required this.authRepository,
    required this.accountService,
  });

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500)).then((value) => init());
  }

  void init() async {
    if (baseService.client.auth.currentUser != null) {
      await accountService.initAccount();
      Get.toNamed(Routes.MAIN);
    } else {
      Get.toNamed(Routes.ONBOARD);
    }
  }
}
