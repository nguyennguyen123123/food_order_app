import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:food_delivery_app/widgets/primary_button.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/two_notifier.dart';
import 'package:get/get.dart';

class ChangeTableDialog extends StatefulWidget {
  const ChangeTableDialog({
    Key? key,
    this.currentTable = '1',
    this.isLimitTableHasOrder = true,
  }) : super(key: key);

  final String currentTable;
  final bool isLimitTableHasOrder;

  @override
  State<ChangeTableDialog> createState() => _ChangeTableDialogState();
}

class _ChangeTableDialogState extends State<ChangeTableDialog> {
  late final ITableRepository tableRepository = Get.find();
  late final IAreaRepository areaRepository = Get.find();
  final areas = ValueNotifier<List<Area>>([]);
  final tableNumberCtrl = TextEditingController();

  final tableNotifier = ValueNotifier<TableModels?>(null);
  final errorTextNotifier = ValueNotifier<String>('');
  // final tableNotifiers = ValueNotifier<List<TableModels>?>(null);
  // final currentTable = ValueNotifier<int>(-1);
  // int page = 0;
  // int limit = LIMIT;
  final currentArea = ValueNotifier<String>('');
  final isLoading = ValueNotifier<bool>(false);
  final showAreas = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    // onRefresh();
    excute(() async {
      areas.value = await areaRepository.getArea();
    });
  }

  @override
  void dispose() {
    errorTextNotifier.dispose();
    currentArea.dispose();
    showAreas.dispose();
    areas.dispose();
    isLoading.dispose();
    tableNotifier.dispose();
    tableNumberCtrl.dispose();
    // tableNotifiers.dispose();
    super.dispose();
  }

  // void onRefresh() async {
  //   tableNotifiers.value = null;
  //   page = 0;
  //   tableNotifiers.value = await tableRepository.getListTableInOrder(page: page, limit: limit);
  // }

  // Future<bool> onLoadMore() async {
  //   final length = tableNotifiers.value?.length ?? 0;
  //   if (length < (page + 1) * limit) return false;

  //   final result = await tableRepository.getListTableInOrder(page: page, limit: limit);
  //   tableNotifiers.value = [...tableNotifiers.value!, ...result];
  //   if (result.length < limit) return false;

  //   return true;
  // }

  void onCheckTable() async {
    isLoading.value = true;
    final number = tableNumberCtrl.text;
    if (number == widget.currentTable) {
      errorTextNotifier.value = 'Không thể chọn bàn hiện tại';
      isLoading.value = false;
      return;
    }
    try {
      final table = await tableRepository.getTableByNumber(number);
      if (table == null) {
        showAreas.value = true;
        currentArea.value = '';
      } else {
        if (widget.isLimitTableHasOrder && table.foodOrder != null) {
          errorTextNotifier.value = 'Bàn hiện tai đang có đơn không thể chuyển được';
        } else {
          tableNotifier.value = table;
          Get.back(result: table);
        }
      }
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  void createTable() async {
    if (currentArea.value.isEmpty) return;
    isLoading.value = true;
    TableModels tableModels = TableModels(
      tableId: getUuid(),
      areaId: currentArea.value,
      tableNumber: tableNumberCtrl.text,
      createdAt: DateTime.now().toString(),
    );
    final newTable = await tableRepository.addTable(tableModels);
    if (newTable != null) {
      Get.back(result: TableModels.fromJson(newTable));
    } else {
      errorTextNotifier.value = 'Tạo bàn thất bại';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(all: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Chọn bàn để chuyển', style: StyleThemeData.bold18()),
          ValueListenableBuilder<String>(
            valueListenable: errorTextNotifier,
            builder: (context, errorText, child) => EditTextFieldCustom(
              label: 'Số bàn',
              controller: tableNumberCtrl,
              hintText: 'Nhập số bàn',
              textInputType: TextInputType.number,
              errorText: errorText,
              isShowErrorText: errorText.isNotEmpty,
            ),
          ),
          TwoValueNotifier<List<Area>, bool>(
            firstNotifier: areas,
            secondNotifier: showAreas,
            itemBuilder: (areas, isShow) => !isShow
                ? SizedBox()
                : ValueListenableBuilder<String>(
                    valueListenable: currentArea,
                    builder: (context, curArea, child) => DropdownButton<String>(
                      value: curArea.isEmpty ? null : curArea,
                      items: areas.map((e) => buildDropDownItem(e.areaId ?? '', e.areaName ?? '')).toList(),
                      onChanged: (value) => currentArea.value = value ?? '',
                    ),
                  ),
          ),
          SizedBox(height: 8.h),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, child) => TwoValueNotifier<TextEditingValue, TableModels?>(
              firstNotifier: tableNumberCtrl,
              secondNotifier: tableNotifier,
              itemBuilder: (text, table) => TwoValueNotifier<bool, String>(
                firstNotifier: showAreas,
                secondNotifier: currentArea,
                itemBuilder: (isShowArea, curArea) => PrimaryButton(
                    onPressed: loading
                        ? () {}
                        : isShowArea
                            ? createTable
                            : table == null
                                ? onCheckTable
                                : () {},
                    radius: BorderRadius.circular(100),
                    isDisable: text.text.isEmpty,
                    contentPadding: padding(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading
                            ? Center(child: CircularProgressIndicator())
                            : Text(
                                isShowArea
                                    ? 'create'.tr
                                    : table == null
                                        ? 'check'.tr
                                        : 'confirm'.tr,
                                textAlign: TextAlign.center,
                                style: StyleThemeData.bold18(color: appTheme.whiteText),
                              ),
                      ],
                    )),
              ),
            ),
          ),
          // TwoValueNotifier<List<TableModels>?, int>(
          //   firstNotifier: tableNotifiers,
          //   secondNotifier: currentTable,
          //   itemBuilder: (tables, currentIndex) => SizedBox(
          //       height: 200.h,
          //       child: tables == null
          //           ? Center(child: CircularProgressIndicator())
          //           : LoadMore(
          //               onLoadMore: onLoadMore,
          //               delegate: LoadMoreDelegateCustom(),
          //               child: ListView.separated(
          //                   itemBuilder: (context, index) => _buildTable(index, tables[index], currentIndex),
          //                   separatorBuilder: (context, index) => Padding(
          //                         padding: padding(vertical: 8),
          //                         child: Divider(height: 1, color: appTheme.borderColor),
          //                       ),
          //                   itemCount: tables.length))),
          // ),
          // PrimaryButton(
          //     onPressed: () => Get.back(result: tableNotifiers.value![currentTable]),
          //     radius: BorderRadius.circular(100),
          //     isDisable: currentTable == -1,
          //     contentPadding: padding(vertical: 4),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'confirm'.tr,
          //           textAlign: TextAlign.center,
          //           style: StyleThemeData.bold18(color: appTheme.whiteText),
          //         ),
          //       ],
          //     ))
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildDropDownItem(String id, String content) {
    return DropdownMenuItem<String>(
      value: id,
      child: Text(content),
    );
  }

  // Widget _buildTable(int index, TableModels table, int currentIndex) {
  //   final isCurrentTable = widget.currentTable == table.tableNumber;
  //   if (isCurrentTable) {
  //     return Opacity(
  //       opacity: isCurrentTable ? 0.2 : 1,
  //       child: Center(child: Text(table.tableNumber.toString())),
  //     );
  //   }
  //   final tableHasOrder = widget.isLimitTableHasOrder && table.foodOrder != null;
  //   return GestureDetector(
  //     onTap: currentIndex == index || tableHasOrder ? null : () => currentTable.value = index,
  //     child: Opacity(
  //       opacity: tableHasOrder ? 0.2 : 1,
  //       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //         if (currentIndex == index) ...[
  //           Icon(Icons.check, size: 15),
  //           SizedBox(width: 12.w),
  //         ],
  //         Text(table.tableNumber.toString()),
  //       ]),
  //     ),
  //   );
  // }
}
