import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final OrderCartService cartService;
  final IOrderRepository orderRepository;

  CartController({required this.cartService, required this.orderRepository});

  final tableNumberController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    orderRepository.getListFoodOrders();
  }

  void updateQuantityCart(int index, int quantity) {
    cartService.items.update((val) {
      val?[index].quantity = quantity;
    });
  }

  Future<void> onPlaceOrder() async {
    if (tableNumberController.text.isEmpty) return;
    excute(() async {
      final result =
          await orderRepository.onPlaceOrder(cartService.items.value, tableNumber: tableNumberController.text);
      if (result != null) {
        cartService.items.value = [];
        print('thanh cong');
      }
    });
  }

  @override
  void onClose() {
    tableNumberController.dispose();
    super.onClose();
  }
}
