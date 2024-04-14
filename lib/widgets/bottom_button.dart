import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({required this.onConfirm, Key? key}) : super(key: key);

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: OutlinedButton(
          child: Text('cancel'.tr, style: StyleThemeData.bold18()),
          onPressed: Get.back,
        )),
        SizedBox(width: 12.w),
        Expanded(
          child: PrimaryButton(
            onPressed: onConfirm,
            child: Text('confirm'.tr, style: StyleThemeData.bold18(color: appTheme.whiteText)),
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
