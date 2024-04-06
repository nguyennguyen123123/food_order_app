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
  void initState() {
    super.initState();
    if (widget.account != null) {
      final acc = widget.account!;
      nameController.text = acc.name ?? '';
      emailController.text = acc.email ?? '';
      roleKey = acc.role ?? '';
      genderKey = acc.gender ?? '';
      roleController.text = USER_ROLE.map[acc.role] ?? '';
      genderController.text = GENDER.map[acc.gender] ?? '';
    }
  }

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
        (widget.account == null && !GetUtils.isEmail(emailController.text))) return;
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
            Text('info_account'.tr, style: StyleThemeData.bold16()),
            EditTextFieldCustom(
              label: 'name'.tr,
              hintText: 'enter_name'.tr,
              controller: nameController,
              isRequire: true,
              isShowErrorText: validateForm.value,
            ),
            SizedBox(height: 8.h),
            EditTextFieldCustom(
              label: 'email'.tr,
              hintText: 'enter_email'.tr,
              isRequire: true,
              canEdit: widget.account == null,
              errorText: 'email_not_valid'.tr,
              validateText: GetUtils.isEmail,
              controller: emailController,
              isShowErrorText: validateForm.value,
            ),
            SizedBox(height: 8.h),
            EditTextFieldCustom(
              label: 'gender'.tr,
              hintText: 'select_gender'.tr,
              isRequire: true,
              controller: genderController,
              isShowErrorText: validateForm.value,
              onItemSelected: (item) => genderKey = item,
              isDropDown: true,
              mapItems: GENDER.map,
            ),
            SizedBox(height: 8.h),
            EditTextFieldCustom(
              label: 'role'.tr,
              hintText: 'select_role'.tr,
              controller: roleController,
              isRequire: true,
              isShowErrorText: validateForm.value,
              onItemSelected: (item) => roleKey = item,
              isDropDown: true,
              mapItems: USER_ROLE.map,
            ),
            SizedBox(height: 12.h),
            ConfirmationButtonWidget(onTap: onSubmit, text: 'confirm'.tr)
          ],
        ),
      ),
    );
  }
}
