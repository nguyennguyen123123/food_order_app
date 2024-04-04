import 'package:flutter/material.dart';
import 'package:food_delivery_app/config/unicode.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/text_form_field_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ValueNotifier<bool> obscurePasswordNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    obscurePasswordNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chào mừng trở lại!',
                  style: StyleThemeData.styleSize28Weight700(),
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Vui lòng nhập thông tin chi tiết của bạn.',
                  style: StyleThemeData.styleSize14Weight400(color: appTheme.greyscale400Color),
                ),
              ),
              SizedBox(height: 36),
              TextFormFieldWidget(
                controller: emailController,
                hintText: 'Email',
                iconData: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email không thể để trống';
                  }
                  if (!emailValid.hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: obscurePasswordNotifier,
                builder: (context, isObscure, chhild) => TextFormFieldWidget(
                  controller: passwordController,
                  hintText: 'Mật khẩu',
                  iconData: Icons.password,
                  passCheck: true,
                  obscure: obscurePasswordNotifier.value,
                  suffixIcon: ValueListenableBuilder<bool>(
                    valueListenable: obscurePasswordNotifier,
                    builder: (context, isObscure, child) {
                      return IconButton(
                        icon: Icon(
                          obscurePasswordNotifier.value ? Icons.visibility : Icons.visibility_off,
                          color: appTheme.greyscale400Color,
                        ),
                        onPressed: () {
                          obscurePasswordNotifier.value = !obscurePasswordNotifier.value;
                        },
                      );
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mật khẩu không thể để trống';
                    }
                    if (value.length < 8) {
                      return 'Mật khẩu phải có ít nhất 8 ký tự';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24),
              ConfirmationButtonWidget(
                isLoading: false,
                onTap: () {},
                text: 'Đăng nhập',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
