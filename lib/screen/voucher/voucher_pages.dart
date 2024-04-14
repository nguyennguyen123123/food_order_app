import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/voucher/voucher_controller.dart';
import 'package:food_delivery_app/screen/voucher/voucher_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/voucher_item.dart';
import 'package:get/get.dart';

class VoucherPages extends GetWidget<VoucherController> {
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
            Text('Voucher', style: StyleThemeData.bold18(height: 0)),
          ],
        ),
        actions: [
          IconButton(onPressed: () => Get.toNamed(Routes.ADDVOUCHER), icon: Icon(Icons.add)),
          SizedBox(width: 12.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding(all: 12),
          child: Obx(
            () => Column(
              children: controller.voucherList.map((voucher) {
                print(voucher.discountType);
                return GestureDetector(
                  onLongPressStart: (ontap) => Get.toNamed(
                    Routes.EDITVOUCHER,
                    arguments: VoucherParameter(voucher: voucher),
                  ),
                  child: Padding(padding: padding(vertical: 12), child: VoucherItem(voucher: voucher)),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemTextWidget(String titile, String data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titile, style: StyleThemeData.bold18(height: 0)),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(data, style: StyleThemeData.bold14(height: 0), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
