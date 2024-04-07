import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_type.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/food/food_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/show_no_system_widget.dart';
import 'package:get/get.dart';

class FoodScreen extends GetWidget<FoodController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.transparentColor,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => controller.addRandomFood(),
              icon: Icon(Icons.ad_units, color: appTheme.blackColor),
            ),
          ],
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: appTheme.blackColor),
              ),
              Text('Tạo menu', style: StyleThemeData.bold18(height: 0)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => Padding(
              padding: padding(all: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.ADDTYPEFOOD);
                        },
                        child: Container(
                          padding: padding(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: appTheme.appColor),
                          ),
                          child: Text('Thêm phân loại', style: StyleThemeData.regular14(height: 0)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.ADDFOOD);
                        },
                        child: Container(
                          padding: padding(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: appTheme.appColor),
                          ),
                          child: Text('Thêm món', style: StyleThemeData.regular14(height: 0)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 90.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.foodTypeList.length,
                      itemBuilder: (context, index) {
                        FoodType foodType = controller.foodTypeList[index];
                        return Container(
                          margin: EdgeInsets.all(8),
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: NetworkImage(foodType.image ?? '')),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 290.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.foodList.length,
                      itemBuilder: (context, index) {
                        FoodModel food = controller.foodList[index];
                        return Container(
                          padding: padding(horizontal: 12),
                          margin: EdgeInsets.all(8),
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: food.image ?? '',
                                fit: BoxFit.cover,
                                width: 120.w,
                                height: 120.h,
                                errorWidget: (context, url, error) {
                                  return Image.asset('assets/logo.jpg');
                                },
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'Tên: ${food.name}',
                                style: StyleThemeData.bold18(),
                                textAlign: TextAlign.center,
                              ),
                              Text('Mô tả: ${food.description}', style: StyleThemeData.regular14()),
                              Text('Giá: ${food.price}', style: StyleThemeData.regular14()),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showNoSystemWidget(
                                        context,
                                        title: 'Xác nhận xóa',
                                        des: 'Bạn chắc chắn muốn xóa món ăn này.',
                                        cancel: 'Hủy',
                                        confirm: 'Xác nhận',
                                        ontap: () {
                                          Navigator.pop(context);
                                          controller.deleteFood(food.foodId.toString());
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: padding(horizontal: 16, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: appTheme.errorColor),
                                      ),
                                      child: Text('Xóa', style: StyleThemeData.regular14(height: 0)),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.ADDFOOD, arguments: food);
                                    },
                                    child: Container(
                                      padding: padding(horizontal: 16, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: appTheme.appColor,
                                      ),
                                      child: Text(
                                        'Chỉnh sửa',
                                        style: StyleThemeData.regular14(color: appTheme.whiteText, height: 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
