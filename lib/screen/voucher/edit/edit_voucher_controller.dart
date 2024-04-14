import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/voucher/ivoucher_repository.dart';
import 'package:food_delivery_app/screen/voucher/voucher_controller.dart';
import 'package:food_delivery_app/screen/voucher/voucher_parameter.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:get/get.dart';

class EditVoucherController extends GetxController {
  final VoucherParameter? parameter;
  final IVoucherRepository voucherepository;

  Voucher? get voucherParametar => parameter?.voucher;

  EditVoucherController({required this.voucherepository, this.parameter});

  late TextEditingController nameController;
  late TextEditingController discountValueController;

  var isLoadingAdd = false.obs;
  var isLoadingDelete = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: voucherParametar?.name.toString());
    discountValueController = TextEditingController(text: voucherParametar?.discountValue.toString());
  }

  void editVoucher() async {
    final voucherId = voucherParametar?.voucherId ?? '';
    if (voucherId.isEmpty) return;

    try {
      isLoadingAdd(true);

      Voucher voucher = Voucher(
        voucherId: voucherId,
        code: voucherParametar?.code,
        discountValue: double.tryParse(discountValueController.text.replaceAll(',', '')),
        discountType: DiscountType.percentage,
        name: nameController.text,
        expiryDate: DateTime.now().toString(),
        createdAt: voucherParametar?.createdAt,
      );

      final result = await voucherepository.editVoucher(voucherId, voucher);

      if (result != null) {
        Get.back();
        Get.find<VoucherController>().updateTable(result);
        DialogUtils.showSuccessDialog(content: "edit_successfully".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "edit_failed".tr);
      }

      isLoadingAdd(false);
    } catch (error) {
      print(error);
    } finally {
      isLoadingAdd(false);
    }
  }

  void deleteVoucher() async {
    final voucherId = voucherParametar?.voucherId ?? '';

    if (voucherId.isEmpty) return;
    try {
      isLoadingDelete(true);

      final delete = await voucherepository.deleteVoucher(voucherId);
      if (delete != null) {
        Get.find<VoucherController>().voucherList.removeWhere((voucher) => voucher.voucherId == voucherId);
        Get.back();
        DialogUtils.showSuccessDialog(content: "delete_successful".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "delete_failed".tr);
      }

      isLoadingDelete(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "delete_failed".tr);
    } finally {
      isLoadingDelete(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    discountValueController.dispose();
  }
}
