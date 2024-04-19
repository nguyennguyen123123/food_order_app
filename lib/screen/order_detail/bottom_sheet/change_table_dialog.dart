import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/two_notifier.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';

class ChangeTableDialog extends StatefulWidget {
  const ChangeTableDialog({Key? key, this.currentTable = 1}) : super(key: key);

  final int currentTable;

  @override
  State<ChangeTableDialog> createState() => _ChangeTableDialogState();
}

class _ChangeTableDialogState extends State<ChangeTableDialog> {
  late final ITableRepository tableRepository = Get.find();

  final tableNotifiers = ValueNotifier<List<TableModels>?>(null);
  final currentTable = ValueNotifier<int>(-1);
  int page = 0;
  int limit = LIMIT;
  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  void dispose() {
    tableNotifiers.dispose();
    super.dispose();
  }

  void onRefresh() async {
    tableNotifiers.value = null;
    page = 0;
    tableNotifiers.value = await tableRepository.getListTableInOrder(page: page, limit: limit);
  }

  Future<bool> onLoadMore() async {
    final length = tableNotifiers.value?.length ?? 0;
    if (length < (page + 1) * limit) return false;

    final result = await tableRepository.getListTableInOrder(page: page, limit: limit);
    tableNotifiers.value = [...tableNotifiers.value!, ...result];
    if (result.length < limit) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(all: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Chọn bàn để chuyển', style: StyleThemeData.bold18()),
          TwoValueNotifier<List<TableModels>?, int>(
            firstNotifier: tableNotifiers,
            secondNotifier: currentTable,
            itemBuilder: (tables, currentIndex) => SizedBox(
                height: 200.h,
                child: tables == null
                    ? Center(child: CircularProgressIndicator())
                    : LoadMore(
                        onLoadMore: onLoadMore,
                        delegate: LoadMoreDelegateCustom(),
                        child: ListView.separated(
                            itemBuilder: (context, index) => _buildTable(index, tables[index], currentIndex),
                            separatorBuilder: (context, index) => Padding(
                                  padding: padding(vertical: 8),
                                  child: Divider(height: 1, color: appTheme.borderColor),
                                ),
                            itemCount: tables.length))),
          ),
          ValueListenableBuilder<int>(
            valueListenable: currentTable,
            builder: (context, currentTable, child) => PrimaryButton(
                onPressed: () => Get.back(result: tableNotifiers.value![currentTable]),
                radius: BorderRadius.circular(100),
                isDisable: currentTable == -1,
                contentPadding: padding(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'confirm'.tr,
                      textAlign: TextAlign.center,
                      style: StyleThemeData.bold18(color: appTheme.whiteText),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _buildTable(int index, TableModels table, int currentIndex) {
    // final isCurrentTable = widget.currentTable == table.tableNumber;
    // if (isCurrentTable) {
    //   return Opacity(
    //     opacity: isCurrentTable ? 0.2 : 1,
    //     child: Center(child: Text(table.tableNumber.toString())),
    //   );
    // }
    final tableHasOrder = table.foodOrder != null;
    return GestureDetector(
      onTap: currentIndex == index || tableHasOrder ? null : () => currentTable.value = index,
      child: Opacity(
        opacity: tableHasOrder ? 0.2 : 1,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (currentIndex == index) ...[
            Icon(Icons.check, size: 15),
            SizedBox(width: 12.w),
          ],
          Text(table.tableNumber.toString()),
        ]),
      ),
    );
  }
}
