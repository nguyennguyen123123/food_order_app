import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:food_delivery_app/screen/voucher/voucher_controller.dart';
import 'package:food_delivery_app/screen/voucher/voucher_parameter.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/voucher_item.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';

class VoucherPages extends GetWidget<VoucherController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
            Text('voucher'.tr, style: StyleThemeData.bold18(height: 0)),
          ],
        ),
        actions: [
          IconButton(onPressed: () => Get.toNamed(Routes.ADDVOUCHER), icon: Icon(Icons.add)),
          SizedBox(width: 12.w),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: controller.voucherList.value == null
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: padding(horizontal: 12),
                      child: RefreshIndicator(
                        onRefresh: controller.onRefresh,
                        child: LoadMore(
                          delegate: LoadMoreDelegateCustom(),
                          onLoadMore: controller.onLoadMoreVoucher,
                          child: ListView.separated(
                            itemCount: controller.voucherList.value!.length,
                            separatorBuilder: (context, index) => SizedBox(height: 8.h),
                            itemBuilder: (context, index) => GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => Get.toNamed(
                                Routes.EDITVOUCHER,
                                arguments: VoucherParameter(voucher: controller.voucherList.value![index]),
                              ),
                              child: Padding(
                                padding: padding(vertical: 12),
                                child: VoucherItem(voucher: controller.voucherList.value![index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemTextWidget(String titile, String data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titile, style: StyleThemeData.bold18(height: 0)),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(data, style: StyleThemeData.bold14(height: 0), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
