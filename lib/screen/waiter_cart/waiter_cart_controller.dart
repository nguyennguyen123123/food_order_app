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
import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_parameter.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class WaiterCartController extends GetxController {
  final OrderCartService cartService;
  final IOrderRepository orderRepository;
  final ITableRepository tableRepository;
  final AccountService accountService;
  final WaiterCartParameter parameter;

  WaiterCartController(
      {required this.parameter,
      required this.cartService,
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
  }

  @override
  void onClose() {
    isValidateForm.close();
    isLoading.close();
    tableNumberController.dispose();
    super.onClose();
  }

  /// Tạo thêm gang ở party order
  void onCreateNewPartyOrder() {
    final number = cartService.partyOrders.value.length + 1;
    cartService.partyOrders.update((val) => val?.add(PartyOrder(partyNumber: number, numberOfGangs: 1)));
  }

  /// Cập nhật số lượng món ăn trong đơn hàng mà không thuộc party nào
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

  /// Cập nhật số lượng món ăn thuộc party trong đơn hàng
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

  /// Xóa món ăn trong đơn hàng không thuộc party nào
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

  /// Xóa món ăn của party trong đơn hàng
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

  /// Cập nhật note cho món ăn không thuộc party
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

  /// Cập nhật note cho món ăn trong party
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

  /// Cập nhật voucher cho party
  void updatePartyVoucher(int partyIndex, Voucher voucher) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].voucher = voucher;
    });
  }

  /// Xóa voucher cho party
  void clearVoucherParty(int partyIndex) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].voucher = null;
    });
  }

  /// Xóa party
  void onRemovePartyOrder(int partyIndex) {
    cartService.partyOrders.update((val) {
      val?.removeAt(partyIndex);
    });
  }

  /// Thêm mức độ ưu tiên lên món của món ăn trong party hoặc đơn hàng
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
      cartService.partyOrders.refresh();
    }
  }

  /// Tạo thêm gang trong party
  void onPartyCreateGang(int partyIndex) {
    cartService.partyOrders.update((val) {
      val?[partyIndex].numberOfGangs += 1;
    });
  }

  void onRemoveGangIndexOfCartItem(OrderItem item) {
    cartService.items.update((val) {
      final index =
          val?.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) ??
              -1;
      if (index != -1) {
        val?[index].sortOder = null;
      }
    });
  }

  void onRemoveGangIndexOfPartyCartItem(int partyIndex, OrderItem item) {
    cartService.partyOrders.update((val) {
      final items = val?[partyIndex].orderItems ?? <OrderItem>[];
      final index =
          items.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId);
      if (index != -1) {
        items[index].sortOder = null;
        val?[partyIndex].orderItems = items;
      }
    });
  }

  /// Lên đơn
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
}
