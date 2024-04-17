import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/order_item.dart';
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

  void updateQuantityCart(OrderItem item, int quantity) {
    cartService.items.update((val) {
      final index =
          val?.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) ??
              -1;
      if (index != -1) {
        val?[index].quantity = quantity;
      }
    });
  }

  void updateQuantityPartyItem(int partyIndex, OrderItem item, int quantity) {
    cartService.partyOrders.update((val) {
      final items = val?[partyIndex].orderItems ?? <OrderItem>[];
      final index =
          items.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId);
      if (index != -1) {
        items[index].quantity = quantity;
        val?[partyIndex].orderItems = items;
      }
    });
  }

  void removeItemInOrder(OrderItem item) {
    cartService.items.update((val) {
      final index =
          val?.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) ??
              -1;
      if (index != -1) {
        val?.removeAt(index);
      }
    });
  }

  void removeItemInPartyOrder(int partyIndex, OrderItem item) {
    cartService.partyOrders.update((val) {
      final items = val?[partyIndex].orderItems ?? <OrderItem>[];
      final index =
          items.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId);
      if (index != -1) {
        items.removeAt(index);
        val?[partyIndex].orderItems = items;
      }
    });
  }

  void updateCartItemNote(OrderItem item, String note) {
    cartService.items.update((val) {
      final index =
          val?.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) ??
              -1;
      if (index != -1) {
        val?[index].note = note;
      }
    });
  }

  void updatePartyCartItemNote(int partyIndex, OrderItem item, String note) {
    cartService.partyOrders.update((val) {
      final items = val?[partyIndex].orderItems ?? <OrderItem>[];
      final index =
          items.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId);
      if (index != -1) {
        items[index].note = note;
        val?[partyIndex].orderItems = items;
      }
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

  void updateOrderItemInCart(int gangIndex, List<OrderItem> orderItems, {int? partyIndex}) {
    if (partyIndex == null) {
      final list = [...cartService.items.value];
      for (final item in orderItems) {
        final index = list.indexWhere((element) => element.foodId == item.foodId);
        if (index != -1) {
          list[index].sortOder = gangIndex;
        }
      }
      cartService.items.value = list;
    } else {
      final list = [...(cartService.partyOrders.value[partyIndex].orderItems ?? <OrderItem>[])];
      for (final item in orderItems) {
        final index = list.indexWhere((element) => element.foodId == item.foodId);
        if (index != -1) {
          list[index].sortOder = gangIndex;
        }
      }
      cartService.partyOrders.value[partyIndex].orderItems = list;
    }
  }

  void onPartyCreateGang(int partyIndex) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].numberOfGangs += 1;
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
