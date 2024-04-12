import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/voucher/voucher_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/number_formatter.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AddVoucherView extends GetWidget<VoucherController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
            Text('Add Voucher', style: StyleThemeData.bold18(height: 0)),
          ],
        ),
      ),
      body: Padding(
        padding: padding(all: 12),
        child: Column(
          children: [
            EditTextFieldCustom(
              controller: controller.nameController,
              hintText: 'Nhập tên mã giảm giá',
              label: 'Tên mã giảm giá',
              suffix: Icon(Icons.title),
              textInputType: TextInputType.text,
            ),
            SizedBox(height: 12.h),
            EditTextFieldCustom(
              controller: controller.discountValueController,
              hintText: 'Nhập giá trị giảm giá',
              label: 'Giá trị giảm giá',
              suffix: Icon(Icons.description),
              textInputType: TextInputType.number,
              numberFormat: NumericTextFormatter(),
            ),
            SizedBox(height: 12.h),
            Obx(
              () => ConfirmationButtonWidget(
                isLoading: controller.isLoadingAdd.isTrue,
                onTap: controller.addVoucher,
                text: 'confirm'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
