import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class StaffDialog extends StatefulWidget {
  const StaffDialog({this.account, Key? key}) : super(key: key);

  final Account? account;

  @override
  State<StaffDialog> createState() => _StaffDialogState();
}

class _StaffDialogState extends State<StaffDialog> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final genderController = TextEditingController();
  var roleKey = '';
  var genderKey = '';
  final validateForm = Rx(false);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    roleController.dispose();
    super.dispose();
  }

  void onSubmit() {
    validateForm.value = true;
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        roleKey.isEmpty ||
        genderKey.isEmpty ||
        !GetUtils.isEmail(emailController.text)) return;
    if (widget.account != null) {
      Get.back(
          result: widget.account!.copyWith(
        name: nameController.text,
        email: emailController.text,
        role: roleKey,
        gender: genderKey,
      ));
    } else {
      Get.back(
          result: Account(
        name: nameController.text,
        email: emailController.text,
        role: roleKey,
        gender: genderKey,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(all: 12),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Thông tin nhân viên', style: StyleThemeData.bold16()),
            EditTextFieldCustom(
              label: 'Tên',
              hintText: 'nhập tên',
              controller: nameController,
              isRequire: true,
              isShowErrorText: validateForm.value,
            ),
            SizedBox(height: 8.h),
            EditTextFieldCustom(
              label: 'Email',
              hintText: 'nhập email',
              isRequire: true,
              errorText: 'Email không hợp lệ',
              validateText: GetUtils.isEmail,
              controller: emailController,
              isShowErrorText: validateForm.value,
            ),
            SizedBox(height: 8.h),
            EditTextFieldCustom(
              label: 'Gender',
              hintText: 'Chọn gender',
              isRequire: true,
              controller: genderController,
              isShowErrorText: validateForm.value,
              onItemSelected: (item) => genderKey = item,
              isDropDown: true,
              mapItems: {
                GENDER.MAN: "Nam",
                GENDER.FEMALE: "Nữ",
              },
            ),
            SizedBox(height: 8.h),
            EditTextFieldCustom(
              label: 'Vai trò',
              hintText: 'Chọn vai trò',
              controller: roleController,
              isRequire: true,
              isShowErrorText: validateForm.value,
              onItemSelected: (item) => roleKey = item,
              isDropDown: true,
              mapItems: {
                USER_ROLE.ADMIN: "ADMIN",
                USER_ROLE.STAFF: "STAFF",
              },
            ),
            SizedBox(height: 12.h),
            ConfirmationButtonWidget(onTap: onSubmit, text: 'Xác nhận')
          ],
        ),
      ),
    );
  }
}
