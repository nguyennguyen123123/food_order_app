import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:get/get.dart';

class ChangeTableDialog extends StatefulWidget {
  const ChangeTableDialog({Key? key}) : super(key: key);

  @override
  State<ChangeTableDialog> createState() => _ChangeTableDialogState();
}

class _ChangeTableDialogState extends State<ChangeTableDialog> {
  late final ITableRepository tableRepository = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
