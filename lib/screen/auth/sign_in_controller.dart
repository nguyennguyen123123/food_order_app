import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/routes/pages.dart';
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
    final result = await authRepository.login(emailController.text, passwordController.text);

    if (result != null) {
      Get.offAllNamed(Routes.HOME);
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
