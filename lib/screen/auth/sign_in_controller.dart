import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final IAuthRepository authRepository;
  final AccountService accountService;

  SignInController({required this.authRepository, required this.accountService});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ValueNotifier<bool> obscurePasswordNotifier = ValueNotifier<bool>(true);
  final validateForm = Rx(false);

  void onSubmit() async {
    validateForm.value = true;
    if (!GetUtils.isEmail(emailController.text) || passwordController.text.isEmpty) return;
    try {
      showLoading();
      final result = await authRepository.login(emailController.text, passwordController.text);
      accountService.account.value = await authRepository.getAccountById(result?.id ?? '');
      dissmissLoading();
      Get.toNamed(Routes.MAIN);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    obscurePasswordNotifier.dispose();
    super.onClose();
  }
}
