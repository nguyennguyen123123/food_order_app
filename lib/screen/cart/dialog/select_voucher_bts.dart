import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/voucher/ivoucher_repository.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/bottom_button.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/two_notifier.dart';
import 'package:food_delivery_app/widgets/voucher_item.dart';
import 'package:get/get.dart';

class SelectVoucherBTS extends StatefulWidget {
  const SelectVoucherBTS({this.voucher, Key? key}) : super(key: key);

  final Voucher? voucher;

  @override
  State<SelectVoucherBTS> createState() => _SelectVoucherBTSState();
}

class _SelectVoucherBTSState extends State<SelectVoucherBTS> {
  late final IVoucherRepository voucherRepository = Get.find();

  final vouchersNotifier = ValueNotifier<List<Voucher>?>(null);
  final voucherCustomPrice = TextEditingController();
  final isCustomVoucher = ValueNotifier<bool>(false);
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
    if (widget.voucher != null) {
      if (widget.voucher?.voucherId == null) {
        isCustomVoucher.value = true;
        voucherCustomPrice.text = (widget.voucher?.discountValue ?? 0).toStringAsFixed(2);
      } else {
        currentVoucher.value = widget.voucher;
      }
    }
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
        ValueListenableBuilder<bool>(
          valueListenable: isCustomVoucher,
          builder: (context, isCustom, child) => Row(
            children: [
              Checkbox(
                  value: isCustom,
                  onChanged: (val) {
                    isCustomVoucher.value = val ?? true;
                    if (val == true) {
                      currentVoucher.value = null;
                    }
                  },
                  activeColor: Colors.amber),
              if (isCustom)
                Expanded(
                  child: EditTextFieldCustom(
                    label: 'Số tiền voucher',
                    controller: voucherCustomPrice,
                    hintText: 'Nhập số tiền voucher',
                    textInputType: TextInputType.number,
                  ),
                )
              else
                Text('Tự nhập số tiền', style: StyleThemeData.bold16())
            ],
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
                              onChanged: (val) {
                                currentVoucher.value = voucher;
                                isCustomVoucher.value = false;
                              },
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
        TwoValueNotifier<TextEditingValue, Voucher?>(
          firstNotifier: voucherCustomPrice,
          secondNotifier: currentVoucher,
          itemBuilder: (text, voucher) => BottomButton(
            isDisableConfirm: (!isCustomVoucher.value || text.text.isEmpty) && voucher == null,
            onConfirm: () {
              if (isCustomVoucher.value) {
                Get.back(
                    result: Voucher(
                        discountType: DiscountType.amount,
                        discountValue: double.tryParse(voucherCustomPrice.text) ?? 0.0));
              } else {
                Get.back(result: currentVoucher.value);
              }
            },
          ),
        )
      ],
    );
  }
}
