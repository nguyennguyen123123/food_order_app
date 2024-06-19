import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/screen/table/manage/table_manage_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/confirmation_button_widget.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class AddTableView extends GetWidget<TableManageControlller> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearAddTable();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.transparentColor,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: appTheme.blackText)),
              Text('add_nre_table'.tr, style: StyleThemeData.bold18(height: 0)),
            ],
          ),
        ),
        body: Padding(
          padding: padding(all: 16),
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft, child: Text('area'.tr, style: StyleThemeData.bold14())),
              SizedBox(height: 4.h),
              Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: appTheme.blackColor, width: 1),
                  ),
                  padding: padding(horizontal: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Area>(
                      hint: Text('select_area'.tr, style: StyleThemeData.regular16()),
                      value: controller.selectedAreaType.value,
                      onChanged: (Area? newValue) => controller.onChangeSelectedArea(newValue),
                      items: controller.areaTypeList.map((Area type) {
                        return DropdownMenuItem<Area>(
                          value: type,
                          child: Text(type.areaName ?? ''),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => controller.tablesArea.value == null
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        width: MediaQuery.of(context).size.width.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: appTheme.blackColor, width: 1),
                        ),
                        padding: padding(horizontal: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<TableModels>(
                            hint: Text('list_of_tables'.tr, style: StyleThemeData.regular16()),
                            onChanged: (TableModels? newValue) {},
                            items: controller.tablesArea.value?.map((TableModels table) {
                                  return DropdownMenuItem<TableModels>(
                                    value: table,
                                    child: Text(table.tableNumber ?? ''),
                                  );
                                }).toList() ??
                                [],
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 8.h),
              EditTextFieldCustom(
                controller: controller.tableNumberController,
                hintText: 'enter_table_number'.tr,
                label: 'table_number'.tr,
                suffix: Icon(Icons.title),
                textInputType: TextInputType.number,
              ),
              SizedBox(height: 24.h),
              Obx(
                () => ConfirmationButtonWidget(
                  isLoading: controller.isLoadingAdd.isTrue,
                  onTap: controller.addTable,
                  text: 'confirm'.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
