import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    required this.onConfirm,
    Key? key,
    this.isDisableConfirm = true,
    this.isDisableCancel = false,
    this.onCancel,
    this.confirmText,
    this.cancelText,
  }) : super(key: key);

  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDisableConfirm;
  final bool isDisableCancel;
  final String? confirmText;
  final String? cancelText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Opacity(
          opacity: isDisableCancel ? 0.2 : 1,
          child: OutlinedButton(
            child: Text(cancelText ?? 'cancel'.tr, style: StyleThemeData.bold18()),
            onPressed: isDisableCancel ? null : onCancel ?? Get.back,
          ),
        )),
        SizedBox(width: 12.w),
        Expanded(
          child: PrimaryButton(
            onPressed: onConfirm,
            isDisable: isDisableConfirm,
            child: Text(confirmText ?? 'confirm'.tr, style: StyleThemeData.bold18(color: appTheme.whiteText)),
            contentPadding: padding(vertical: 6),
            backgroundColor: appTheme.primaryColor,
            borderColor: appTheme.primaryColor,
            radius: BorderRadius.circular(1000),
          ),
        )
      ],
    );
  }
}
