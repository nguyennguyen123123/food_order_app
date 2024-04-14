import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/party_order.dart';
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

  var selectedValue = Rx<TableModels?>(null);
  final searchController = TextEditingController();

  List<PartyOrder> get partyOrders => cartService.partyOrders.value;

  @override
  void onInit() {
    super.onInit();
    getListTable();
  }

  @override
  void onClose() {
    isValidateForm.close();
    isLoading.close();
    tableNumberController.dispose();
    super.onClose();
  }

  void onCreateNewPartyOrder() {
    final number = cartService.partyOrders.value.length + 1;
    cartService.partyOrders.update((val) => val?.add(PartyOrder(partyNumber: number)));
  }

  void updateQuantityCart(int index, int quantity) {
    cartService.items.update((val) {
      val?[index].quantity = quantity;
    });
  }

  void updateQuantityPartyItem(int partyIndex, int index, int quantity) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].orderItems?[index].quantity = quantity;
    });
  }

  void removeItemInOrder(int index) {
    cartService.items.update((val) {
      val?.removeAt(index);
    });
  }

  void removeItemInPartyOrder(int partyIndex, int index) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].orderItems?.removeAt(index);
    });
  }

  void updateCartItemNote(int index, String note) {
    cartService.items.update((val) {
      val?[index].note = note;
    });
  }

  void updatePartyCartItemNote(int partyIndex, int index, String note) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].orderItems?[index].note = note;
    });
  }

  Future<void> onPlaceOrder() async {
    isValidateForm.value = true;

    if (selectedValue.value?.tableNumber == null) return;

    isLoading.value = true;
    showLoading();
    try {
      final result = await orderRepository.onPlaceOrder(
        cartService.items.value,
        cartService.partyOrders.value,
        tableNumber: (selectedValue.value?.tableNumber ?? 0).toString(),
      );
      if (result != null) {
        cartService.items.value = [];
        cartService.partyOrders.value = [];
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

  void getListTable() async {
    final result = await tableRepository.getTable();

    if (result != null) {
      tableList.assignAll(result);
    } else {
      tableList.clear();
    }
  }
}
