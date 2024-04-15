import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final OrderCartService cartService;
  final IOrderRepository orderRepository;
  final ITableRepository tableRepository;
  final AccountService accountService;

  CartController(
      {required this.cartService,
      required this.orderRepository,
      required this.tableRepository,
      required this.accountService});

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

  void updatePartyVoucher(int partyIndex, Voucher voucher) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].voucher = voucher;
    });
  }

  void clearVoucherParty(int partyIndex) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].voucher = null;
    });
  }

  void onRemovePartyOrder(int partyIndex) {
    cartService.partyOrders.update((val) {
      val?.removeAt(partyIndex);
    });
  }

  Future<void> onPlaceOrder() async {
    if (accountService.myAccount?.role == USER_ROLE.STAFF && accountService.myAccount?.checkInTime == null) {
      DialogUtils.showInfoErrorDialog(content: 'Bạn chưa checkin nên không thể lên đơn');
      return;
    }

    isValidateForm.value = true;

    if (selectedValue.value?.tableNumber == null) return;

    isLoading.value = true;
    showLoading();
    try {
      final result = await orderRepository.onPlaceOrder(
        cartService.items.value,
        cartService.partyOrders.value,
        voucher: cartService.currentVoucher.value,
        tableNumber: (selectedValue.value?.tableNumber ?? 0).toString(),
        bondNumber: (accountService.myAccount?.numberOfOrder ?? 0) + 1,
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
