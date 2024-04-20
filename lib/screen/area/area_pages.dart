import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/area/area_controller.dart';
import 'package:food_delivery_app/screen/area/area_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/list_vertical_item.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/show_no_system_widget.dart';
import 'package:get/get.dart';

class AreaPages extends GetWidget<AreaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: padding(horizontal: 16),
          child: Text('area'.tr, style: StyleThemeData.bold18(height: 0)),
        ),
        actions: [
          IconButton(onPressed: () => Get.toNamed(Routes.ADDAREA), icon: Icon(Icons.add)),
          SizedBox(width: 12.w),
        ],
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Obx(
          () => controller.areaList.value == null
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: ListVerticalItem<Area>(
                    items: controller.areaList.value!,
                    itemBuilder: (index, item) => GestureDetector(
                      onTap: () => Get.toNamed(Routes.EDITAREA, arguments: AreaParameter(area: item)),
                      onLongPressStart: (details) {
                        showNoSystemWidget(
                          context,
                          title: 'Xóa khu vực'.tr + '?',
                          des: 'Bạn có chắc chắn muốn xóa khu vực'.tr + '?',
                          cancel: 'close'.tr,
                          confirm: 'agree'.tr,
                          ontap: () {
                            controller.deleteTable(item.areaId ?? '');
                          },
                        );
                      },
                      child: Container(
                        padding: padding(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.areaName ?? '',
                          style: StyleThemeData.regular16(),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
