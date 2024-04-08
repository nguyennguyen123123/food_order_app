import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screen/profile/profile_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/edit_text_field_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/show_no_system_widget.dart';
import 'package:get/get.dart';

class MyAccountView extends GetWidget<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (controller.isEditAccountVisible.value)
            showNoSystemWidget(
              context,
              title: 'Xác nhận hủy?',
              des: 'Bạn có chắc chắn muốn hủy và không thể lưu thông tin?',
              cancel: 'Đóng',
              confirm: 'Đồng ý',
              ontap: () {
                Get.back();
                Get.back();
                controller.isEditAccountVisible.value = false;
              },
            );
          else
            Get.back();

          return true;
        },
        child: Scaffold(
          backgroundColor: appTheme.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appTheme.whiteText,
            iconTheme: IconThemeData(color: appTheme.blackColor),
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Padding(
              padding: padding(horizontal: 4),
              child: Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: controller.isEditAccountVisible,
                    builder: (context, showEdit, _) {
                      return IconButton(
                        onPressed: controller.isEditAccountVisible.value
                            ? () {
                                showNoSystemWidget(
                                  context,
                                  title: 'Xác nhận hủy?',
                                  des: 'Bạn có chắc chắn muốn hủy và không thể lưu thông tin?',
                                  cancel: 'Đóng',
                                  confirm: 'Đồng ý',
                                  ontap: () {
                                    Get.back();
                                    Get.back();
                                    controller.isEditAccountVisible.value = false;
                                  },
                                );
                              }
                            : () => Get.back(),
                        icon: const Icon(Icons.arrow_back),
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: controller.isEditAccountVisible,
                    builder: (context, showEdit, _) {
                      return Text(
                        controller.isEditAccountVisible.value ? 'Cập nhật tài khoản' : 'Tài khoản ',
                        style: StyleThemeData.bold18(height: 0),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: padding(horizontal: 16),
                child: Row(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: controller.isEditAccountVisible,
                      builder: (context, showEdit, _) => showEdit
                          ? const SizedBox.shrink()
                          : InkWell(
                              onTap: () {
                                controller.isEditAccountVisible.value = true;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: appTheme.appColor),
                                ),
                                child: Text(
                                  'Chỉnh sửa',
                                  style: StyleThemeData.bold14(color: appTheme.appColor, height: 0),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: informationData(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ValueListenableBuilder<bool>(
            valueListenable: controller.isEditAccountVisible,
            builder: (context, showEdit, _) => showEdit
                ? Padding(
                    padding: padding(horizontal: 16, vertical: 16),
                    child: FittedBox(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.isEditAccountVisible.value = false;
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.w,
                              height: 40.h,
                              alignment: Alignment.center,
                              padding: padding(vertical: 9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: appTheme.appColor),
                              ),
                              child: Text(
                                'Hủy',
                                style: StyleThemeData.bold14(color: appTheme.appColor, height: 0),
                              ),
                            ),
                          ),
                          SizedBox(width: 24.w),
                          InkWell(
                            onTap: () async {
                              controller.updateProfile();
                              Get.back();
                              controller.isEditAccountVisible.value = false;
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.w,
                              height: 40.h,
                              alignment: Alignment.center,
                              padding: padding(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: appTheme.appColor,
                              ),
                              // child: authController.isUpdateLoading.isTrue
                              //     ? Center(
                              //         child: SpinKitFadingCircle(
                              //           size: 25,
                              //           color: appTheme.whiteText,
                              //         ),
                              //       )
                              //     : Text(
                              //         'Cập nhật thông tin',
                              //         style: StyleThemeData.bold14(color: appTheme.whiteText, height: 0),
                              //       ),
                              child: Text(
                                'Cập nhật thông tin',
                                style: StyleThemeData.bold14(color: appTheme.whiteText, height: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget informationData() {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isEditAccountVisible,
      builder: (context, showEdit, _) {
        return Container(
          color: appTheme.whiteText,
          padding: padding(all: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin cá nhân',
                style: StyleThemeData.bold14(),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: padding(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditTextFieldCustom(
                      controller: controller.nameController,
                      hintText: 'Nhập tên',
                      label: 'Tên',
                      enabled: showEdit,
                      suffix: Icon(Icons.account_circle_sharp),
                      textInputType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: padding(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120.w,
                      child: Text(
                        'Giới tính',
                        style: StyleThemeData.bold14(color: appTheme.textDesColor, height: 0),
                      ),
                    ),
                    _buildGenderIcon('Nam', 'MAN', clickOntap: showEdit),
                    SizedBox(width: 18.w),
                    _buildGenderIcon('Nữ', 'FEMALE', clickOntap: showEdit),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderIcon(
    String label,
    String gender, {
    bool clickOntap = false,
  }) {
    return Obx(() {
      bool isSelected = controller.account.value.gender == gender;

      return GestureDetector(
        onTap: clickOntap
            ? () {
                controller.handleClick(gender);
              }
            : null,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? appTheme.primary40Color : appTheme.blackColor, width: 2),
              ),
              child:
                  Icon(Icons.circle, color: isSelected ? appTheme.primary40Color : appTheme.transparentColor, size: 16),
            ),
            SizedBox(width: 4.w),
            Text(label, style: StyleThemeData.bold14(height: 0)),
          ],
        ),
      );
    });
  }
}
