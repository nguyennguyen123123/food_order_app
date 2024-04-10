import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/screen/staff_manage/staff_manage_controller.dart';
import 'package:food_delivery_app/screen/staff_manage/widget/staff_dialog.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';

class StaffManagePage extends GetWidget<StaffManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          actions: [
            GestureDetector(
              onTap: () async {
                final result = await DialogUtils.showDialogView(StaffDialog());
                if (result != null) {
                  controller.onAddAccount(result);
                }
              },
              child: Icon(
                Icons.add,
                color: appTheme.whiteText,
                size: 25.w,
              ),
            ),
            GestureDetector(
              onTap: controller.onAddRandomAccount,
              child: Icon(
                Icons.abc_rounded,
                color: appTheme.whiteText,
                size: 25.w,
              ),
            ),
          ],
          backgroundColor: appTheme.primaryColor),
      body: Padding(
        padding: padding(all: 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 1, child: Text('name'.tr, style: StyleThemeData.bold12())),
                Expanded(flex: 2, child: Text('email'.tr, style: StyleThemeData.bold12())),
                Expanded(flex: 1, child: SizedBox())
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: Obx(
                () => controller.accounts.value == null
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: controller.onRefresh,
                        child: LoadMore(
                          delegate: LoadMoreDelegateCustom(),
                          onLoadMore: controller.onLoadMore,
                          child: ListView.separated(
                            itemCount: controller.accounts.value!.length,
                            separatorBuilder: (context, index) => SizedBox(height: 8.h),
                            itemBuilder: (context, index) => _buildStaffView(index, controller.accounts.value![index]),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffView(int index, Account account) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(account.name ?? '', style: StyleThemeData.regular14())),
        Expanded(flex: 2, child: Text(account.email ?? '', style: StyleThemeData.regular14())),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await DialogUtils.showYesNoDialog(title: 'delete_account'.tr);
                  if (result == true) {
                    controller.onRemoveAccount(index, account);
                  }
                },
                child: Icon(Icons.remove_circle_outline),
              ),
              GestureDetector(
                onTap: () async {
                  final result = await DialogUtils.showDialogView(StaffDialog(account: account));
                  if (result != null) {
                    controller.updateAccount(index, result);
                  }
                },
                child: Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
