import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/screen/staff_in_working/staff_in_working_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/line_item_view.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

class StaffInWorkingPage extends GetWidget<StaffInWorkingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('manage_staff'.tr, style: StyleThemeData.bold18(color: appTheme.whiteText)),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: appTheme.whiteText,
              size: 25.w,
            ),
          ),
          backgroundColor: appTheme.primaryColor),
      body: Obx(() {
        if (controller.accountList.value == null || controller.summarizeOrder.value == null) {
          return Center(child: CircularProgressIndicator());
        }
        final total = controller.accountList.value!
            .fold<double>(0.0, (previousValue, element) => previousValue + element.totalOrderPrice);

        final today = controller.summarizeOrder.value!;
        final day = '${today.day}-${today.month}-${today.year}';

        return Padding(
          padding: padding(all: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ngày: $day', style: StyleThemeData.bold14()),
              SizedBox(height: 8.h),
              Text('Tổng doanh thu: ${Utils.getCurrency(today.totalOrderPrice)}'),
              SizedBox(height: 12.h),
              Text(
                'Tổng doanh thu hiện tại của các nhân viên trong ca làm: ${Utils.getCurrency(total)}',
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.accountList.value!.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) => _buildAccountWorking(controller.accountList.value![index]),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAccountWorking(Account account) {
    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appTheme.blackColor),
        color: appTheme.primary40Color.withOpacity(0.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LineItemView(title: 'Tên nhân viên', content: account.name ?? ''),
          SizedBox(height: 8.h),
          LineItemView(title: 'Email', content: account.email ?? ''),
          SizedBox(height: 8.h),
          Divider(height: 1, color: appTheme.blackColor),
          SizedBox(height: 8.h),
          LineItemView(title: 'Tổng tiền', content: Utils.getCurrency(account.totalOrderPrice)),
        ],
      ),
    );
  }
}
