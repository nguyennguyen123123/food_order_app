import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:get/get.dart';

void showLoading() {
  EasyLoading.show(maskType: EasyLoadingMaskType.black);
}

void dissmissLoading() {
  EasyLoading.dismiss();
}

Future<void> excute(Future<void> Function() function) async {
  try {
    showLoading();
    await function.call();
  } catch (e) {
    await DialogUtils.showInfoErrorDialog(content: 'try_again'.tr);
    print(e);
  } finally {
    dissmissLoading();
  }
}
