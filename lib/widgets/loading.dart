import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading() {
  EasyLoading.show();
}

void dissmissLoading() {
  EasyLoading.dismiss();
}

Future<void> excute(Future<void> Function() function) async {
  try {
    EasyLoading.show();
    function.call();
  } catch (e) {
    print(e);
  } finally {
    EasyLoading.dismiss();
  }
}
