import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/cupon_clipper.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:intl/intl.dart';

class VoucherItem extends StatelessWidget {
  const VoucherItem({
    required this.voucher,
    Key? key,
  }) : super(key: key);

  final Voucher voucher;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CouponClipper(),
      child: Container(
        // height: 120.h,
        // width: 400.w,
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
                      // Spacer(),
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
