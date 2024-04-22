import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/area/area_controller.dart';
import 'package:food_delivery_app/screen/area/area_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
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
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
            Text('area'.tr, style: StyleThemeData.bold18(height: 0)),
          ],
        ),
        actions: [
          IconButton(onPressed: () => Get.toNamed(Routes.ADDAREA), icon: Icon(Icons.add)),
          SizedBox(width: 12.w),
        ],
      ),
      body: Padding(
        padding: padding(all: 16),
        child: Obx(
          () => controller.areaList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: ListView.separated(
                    itemCount: controller.areaList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final area = controller.areaList[index];

                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.EDITAREA, arguments: AreaParameter(area: area)),
                        onLongPressStart: (details) {
                          showNoSystemWidget(
                            context,
                            title: 'Xóa khu vực'.tr + '?',
                            des: 'Bạn có chắc chắn muốn xóa khu vực'.tr + '?',
                            cancel: 'close'.tr,
                            confirm: 'agree'.tr,
                            ontap: () {
                              controller.deleteTable(area.areaId ?? '');
                            },
                          );
                        },
                        child: Container(
                          padding: padding(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            area.areaName ?? '',
                            style: StyleThemeData.regular16(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
