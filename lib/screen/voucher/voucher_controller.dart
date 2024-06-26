import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
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

  var voucherList = Rx<List<Voucher>?>([]);

  final selectedType = Rx<DiscountType>(DiscountType.percentage);

  int page = 0;
  int limit = LIMIT;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
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

  Future<void> onRefresh() async {
    page = 0;
    voucherList.value = null;

    final result = await voucherepository.getVoucher(page: page, limit: limit);

    voucherList.value = result;
  }

  Future<bool> onLoadMoreVoucher() async {
    final length = (voucherList.value ?? []).length;
    if (length < LIMIT * (page + 1)) return false;
    page += 1;

    final result = await voucherepository.getVoucher(page: page, limit: limit);

    voucherList.update((val) => val?.addAll(result));
    if (result.length < limit) return false;
    return true;
  }

  void addVoucher() async {
    if (nameController.text.isEmpty || discountValueController.text.isEmpty) return;

    try {
      isLoadingAdd(true);

      String randomString = generateRandomString();

      Voucher voucher = Voucher(
        voucherId: getUuid(),
        code: randomString,
        discountValue: double.tryParse(discountValueController.text.replaceAll(',', '')),
        discountType: selectedType.value,
        name: nameController.text,
        expiryDate: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
      );

      final result = await voucherepository.addVoucher(voucher);

      if (result != null) {
        final newVoucher = Voucher.fromJson(result);

        voucherList.value = [...voucherList.value ?? [], newVoucher];

        Get.back();
        clear();
        DialogUtils.showSuccessDialog(content: "add_voucher_successful".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "add_voucher_failed".tr);
      }

      isLoadingAdd(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "add_voucher_failed".tr);
    } finally {
      isLoadingAdd(false);
    }
  }

  void updateTable(Voucher updatedVoucher) {
    final index = voucherList.value?.indexWhere((voucher) => voucher.voucherId == updatedVoucher.voucherId);
    if (index != -1 && voucherList.value != null) {
      final newList = List<Voucher>.from(voucherList.value!);
      newList[index!] = updatedVoucher;
      voucherList.value = newList;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    discountValueController.dispose();
  }
}
