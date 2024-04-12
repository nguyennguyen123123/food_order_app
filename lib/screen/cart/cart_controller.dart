import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final OrderCartService cartService;
  final IOrderRepository orderRepository;
  final ITableRepository tableRepository;

  CartController({required this.cartService, required this.orderRepository, required this.tableRepository});

  final isLoading = false.obs;
  final isValidateForm = false.obs;

  final tableNumberController = TextEditingController();

  var tableList = <TableModels>[].obs;

  var selectedValue = TableModels().obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getListTable();
  }

  void updateQuantityCart(int index, int quantity) {
    cartService.items.update((val) {
      val?[index].quantity = quantity;
    });
  }

  Future<void> onPlaceOrder() async {
    isValidateForm.value = true;

    // if (tableNumberController.text.isEmpty) return;
    if (selectedValue.value.tableNumber == null) return;

    isLoading.value = true;
    showLoading();
    try {
      final result = await orderRepository.onPlaceOrder(
        cartService.items.value,
        tableNumber: selectedValue.value.tableNumber.toString(),
      );
      if (result != null) {
        cartService.items.value = [];
        DialogUtils.showSuccessDialog(content: "create_order_success".tr);
      } else {
        DialogUtils.showInfoErrorDialog(content: "create_order_fail".tr);
      }
    } catch (e) {
      print(e);
      DialogUtils.showInfoErrorDialog(content: "create_order_fail".tr);
    }
    isLoading.value = false;
    dissmissLoading();
  }

  @override
  void onClose() {
    isValidateForm.close();
    isLoading.close();
    tableNumberController.dispose();
    super.onClose();
  }

  void getListTable() async {
    final result = await tableRepository.getTable();

    if (result != null) {
      tableList.assignAll(result);
    } else {
      tableList.clear();
    }
  }
}
