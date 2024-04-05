import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/food/food_controller.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
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
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: appTheme.blackColor),
              ),
              Text('Thêm món', style: StyleThemeData.bold18(height: 0)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                SizedBox(height: 36.h),
                Obx(
                  () => Container(
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
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
