import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final OrderCartService cartService;
  final IOrderRepository orderRepository;

  CartController({required this.cartService, required this.orderRepository});

  final tableNumberController = TextEditingController();

  void updateQuantityCart(int index, int quantity) {
    cartService.items.update((val) {
      val?[index].quantity = quantity;
    });
  }

  Future<void> onPlaceOrder() async {
    if (tableNumberController.text.isEmpty) return;
    showLoading();
    try {
      final result =
          await orderRepository.onPlaceOrder(cartService.items.value, tableNumber: tableNumberController.text);
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
    dissmissLoading();
  }

  @override
  void onClose() {
    tableNumberController.dispose();
    super.onClose();
  }
}
