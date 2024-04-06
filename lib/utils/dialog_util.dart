import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static showDialogView(Widget view) {
    return showDialog(context: Get.context!, useRootNavigator: false, builder: (context) => Dialog(child: view));
  }
}
