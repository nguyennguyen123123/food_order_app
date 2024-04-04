import 'package:flutter/material.dart';
import 'package:food_delivery_app/screen/auth/sign_in_controller.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:get/get.dart';

class SignInScreen extends GetWidget<SignInController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 36),
            EditTextFieldCustom(
              controller: controller.emailController,
              hintText: 'Email',
              label: 'Email',
              suffix: Icon(Icons.email_outlined),
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: controller.obscurePasswordNotifier,
              builder: (context, isObscure, chhild) => EditTextFieldCustom(
                controller: controller.passwordController,
                hintText: 'Mật khẩu',
                label: 'Mật khẩu',
                suffix: GestureDetector(
                    onTap: () => controller.obscurePasswordNotifier.value = !controller.obscurePasswordNotifier.value,
                    child: Icon(controller.obscurePasswordNotifier.value ? Icons.visibility : Icons.visibility_off)),
                isObscure: isObscure,
                textInputType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 24),
            ConfirmationButtonWidget(
              isLoading: false,
              onTap: controller.onSubmit,
              text: 'Đăng nhập',
            ),
          ],
        ),
      ),
    );
  }
}
