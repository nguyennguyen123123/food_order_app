import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class EditReasonBottomSheet extends StatefulWidget {
  const EditReasonBottomSheet({Key? key, this.reason = ''}) : super(key: key);

  final String reason;

  @override
  State<EditReasonBottomSheet> createState() => _EditReasonBottomSheetState();
}

class _EditReasonBottomSheetState extends State<EditReasonBottomSheet> {
  final textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    textCtrl.text = widget.reason;
  }

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(all: 12),
      child: Column(
        children: [
          EditTextFieldCustom(
            label: 'note'.tr,
            controller: textCtrl,
            hintText: 'enter_note'.tr,
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                child: Text('cancel'.tr, style: StyleThemeData.bold18()),
                onPressed: Get.back,
              )),
              SizedBox(width: 12.w),
              Expanded(
                child: PrimaryButton(
                  onPressed: () => Get.back(result: textCtrl.text),
                  child: Text('confirm'.tr, style: StyleThemeData.bold18(color: appTheme.whiteText)),
                  contentPadding: padding(vertical: 6),
                  backgroundColor: appTheme.primaryColor,
                  borderColor: appTheme.primaryColor,
                  radius: BorderRadius.circular(1000),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
