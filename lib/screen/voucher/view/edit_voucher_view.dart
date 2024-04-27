import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/screen/voucher/edit/edit_voucher_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/number_formatter.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class EditVoucherView extends GetWidget<EditVoucherController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.transparentColor,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
              Text('edit_voucher'.tr, style: StyleThemeData.bold18(height: 0)),
            ],
          ),
        ),
        body: Padding(
          padding: padding(all: 12),
          child: Column(
            children: [
              EditTextFieldCustom(
                controller: controller.nameController,
                hintText: 'enter_voucher_name'.tr,
                label: 'voucher_name'.tr,
                suffix: Icon(Icons.title),
                textInputType: TextInputType.text,
              ),
              SizedBox(height: 12.h),
              Obx(() {
                // final inputFormatter = controller.selectedType.value == DiscountType.percentage
                //     ? FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                //     : FilteringTextInputFormatter.digitsOnly;

                return EditTextFieldCustom(
                  controller: controller.discountValueController,
                  hintText: 'enter_discount_value'.tr,
                  label: 'discount_value'.tr,
                  suffix: Icon(Icons.description),
                  textInputType: TextInputType.number,
                  numberFormat: controller.selectedType.value == DiscountType.percentage
                      ? PercentageTextFormatter()
                      : NumericTextFormatter(),
                  // inputFormatter: inputFormatter,
                );
              }),
              SizedBox(height: 12.h),
              Align(alignment: Alignment.centerLeft, child: Text('unit'.tr, style: StyleThemeData.bold14())),
              SizedBox(height: 4.h),
              Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: appTheme.blackColor, width: 1),
                  ),
                  padding: padding(horizontal: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DiscountType>(
                      hint: Text('select_unit'.tr, style: StyleThemeData.regular16()),
                      value: controller.selectedType.value,
                      onChanged: (DiscountType? newValue) {
                        controller.selectedType.value = newValue!;
                        controller.discountValueController.clear();
                      },
                      items: DiscountType.values.map((type) {
                        return DropdownMenuItem<DiscountType>(
                          value: type,
                          child: Text(_getDisplayText(type)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Obx(
                () => Row(
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: controller.deleteVoucher,
                        child: Container(
                          width: Get.size.width.w,
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: appTheme.errorColor),
                          ),
                          child: controller.isLoadingDelete.isTrue
                              ? Container(width: 20.w, height: 20.h, child: CircularProgressIndicator())
                              : Text('delete'.tr, style: StyleThemeData.bold18(height: 0, color: appTheme.errorColor)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: InkWell(
                        onTap: controller.editVoucher,
                        child: Container(
                          width: Get.size.width.w,
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: appTheme.appColor,
                          ),
                          child: controller.isLoadingAdd.isTrue
                              ? Container(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(color: appTheme.whiteText),
                                )
                              : Text('edit'.tr, style: StyleThemeData.bold18(height: 0, color: appTheme.whiteText)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayText(DiscountType type) {
    switch (type) {
      case DiscountType.percentage:
        return 'percentage'.tr;
      case DiscountType.amount:
        return 'amount'.tr;
    }
  }
}
