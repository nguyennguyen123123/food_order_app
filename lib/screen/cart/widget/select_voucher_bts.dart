import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/voucher/ivoucher_repository.dart';
import 'package:food_delivery_app/widgets/bottom_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/two_notifier.dart';
import 'package:food_delivery_app/widgets/voucher_item.dart';
import 'package:get/get.dart';

class SelectVoucherBTS extends StatefulWidget {
  const SelectVoucherBTS({Key? key}) : super(key: key);

  @override
  State<SelectVoucherBTS> createState() => _SelectVoucherBTSState();
}

class _SelectVoucherBTSState extends State<SelectVoucherBTS> {
  late final IVoucherRepository voucherRepository = Get.find();

  final vouchersNotifier = ValueNotifier<List<Voucher>?>(null);

  final currentVoucher = ValueNotifier<Voucher?>(null);

  int page = 0;
  final limit = LIMIT;

  @override
  void dispose() {
    vouchersNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    onGetAllVouchers();
  }

  Future<void> onGetAllVouchers() async {
    vouchersNotifier.value = null;
    page = 0;
    vouchersNotifier.value = await voucherRepository.getVoucher();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: Get.back,
            child: Icon(
              Icons.close,
              size: 24,
              color: appTheme.blackColor,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: TwoValueNotifier<List<Voucher>?, Voucher?>(
            firstNotifier: vouchersNotifier,
            secondNotifier: currentVoucher,
            itemBuilder: (vouchers, curVoucher) {
              if (vouchers == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      final voucher = vouchers[index];
                      final isSelectVoucher = curVoucher?.voucherId == voucher.voucherId;
                      return Row(
                        children: [
                          Checkbox(
                              value: isSelectVoucher,
                              onChanged: (val) => currentVoucher.value = voucher,
                              activeColor: Colors.amber),
                          Expanded(child: VoucherItem(voucher: voucher)),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 8.h),
                    itemCount: vouchers.length);
              }
            },
          ),
        ),
        SizedBox(height: 12.h),
        BottomButton(
          onConfirm: () => Get.back(result: currentVoucher.value),
        )
      ],
    );
  }
}
