import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/voucher/voucher_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/cupon_clipper.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                return Padding(
                  padding: padding(vertical: 12),
                  child: ClipPath(
                    clipper: CuponClipper(),
                    child: Container(
                      height: 120,
                      width: 400,
                      alignment: Alignment.center,
                      color: Colors.amber,
                      child: Padding(
                        padding: padding(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                voucher.code.toString(),
                                style: StyleThemeData.bold18(color: appTheme.whiteText),
                              ),
                            ),
                            Container(
                              height: 90,
                              width: 2,
                              color: appTheme.whiteText,
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: padding(vertical: 12, horizontal: 8),
                                child: Column(
                                  children: [
                                    itemTextWidget('Tên:', voucher.name.toString()),
                                    SizedBox(height: 4.h),
                                    if (voucher.discountType == DiscountType.percentage)
                                      Text(
                                        voucher.discountValue.toString() + '%',
                                        style: StyleThemeData.bold24(height: 0),
                                      )
                                    else
                                      Text(
                                        Utils.getCurrency(voucher.discountValue?.toInt()),
                                        style: StyleThemeData.bold24(height: 0),
                                      ),
                                    Spacer(),
                                    itemTextWidget(
                                      'Hạn sử dụng:',
                                      DateFormat('dd/MM/yyyy').format(DateTime.parse(voucher.expiryDate.toString())),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
