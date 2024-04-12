import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/voucher/ivoucher_repository.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class VoucherController extends GetxController {
  final IVoucherRepository voucherepository;

  VoucherController({required this.voucherepository});

  var isLoadingAdd = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController discountValueController = TextEditingController();

  var voucherList = <Voucher>[].obs;

  @override
  void onInit() {
    super.onInit();
    getListVoucher();
  }

  void clear() {
    nameController.clear();
    discountValueController.clear();
  }

  String generateRandomString() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String result = '';

    for (var i = 0; i < 6; i++) {
      result += chars[random.nextInt(chars.length)];
    }

    return result.toUpperCase();
  }

  void getListVoucher() async {
    final result = await voucherepository.getVoucher();

    if (result != null) {
      voucherList.assignAll(result);
    } else {
      voucherList.clear();
    }
  }

  void addVoucher() async {
    if (nameController.text.isEmpty || discountValueController.text.isEmpty) return;

    try {
      isLoadingAdd(true);

      String randomString = generateRandomString();

      Voucher voucher = Voucher(
        voucherId: getUuid(),
        code: randomString,
        discountValue: int.tryParse(discountValueController.text.replaceAll(',', '')),
        discountType: DiscountType.amount,
        name: nameController.text,
        expiryDate: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
      );

      final result = await voucherepository.addVoucher(voucher);

      if (result != null) {
        final voucher = Voucher.fromJson(result);

        voucherList.add(voucher);

        Get.back();
        clear();
        DialogUtils.showSuccessDialog(content: "Thêm voucher thành công".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "Thêm voucher thất bại".tr);
      }

      isLoadingAdd(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "Thêm voucher thất bại".tr);
    } finally {
      isLoadingAdd(false);
    }
  }

  void updateTable(Voucher updatedVoucher) {
    final index = voucherList.indexWhere((voucher) => voucher.voucherId == updatedVoucher.voucherId);
    if (index != -1) {
      voucherList[index] = updatedVoucher;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    discountValueController.dispose();
  }
}
