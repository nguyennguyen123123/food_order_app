import 'dart:math';

import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/resourese/service/printer_service.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/screen/waiter_cart/waiter_cart_parameter.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class WaiterCartController extends GetxController {
  final OrderCartService cartService;
  final IOrderRepository orderRepository;
  final ITableRepository tableRepository;
  final AccountService accountService;
  final WaiterCartParameter parameter;
  final PrinterService printerService;

  WaiterCartController({
    required this.parameter,
    required this.cartService,
    required this.orderRepository,
    required this.tableRepository,
    required this.accountService,
    required this.printerService,
  });

  final isLoading = false.obs;

  final currentPartySelected = Rx<int>(0);

  List<PartyOrder> get partyOrders => cartService.partyOrders.value;
  final numberOfGang = 0.obs;

  @override
  void onClose() {
    numberOfGang.close();
    isLoading.close();
    currentPartySelected.close();
    super.onClose();
  }

  bool get isEmptyCart {
    // final isEmptyItems = cartService.items.value.isEmpty;
    final isEmptyPartyOrder = cartService.partyOrders.value.isEmpty;
    if ((isEmptyPartyOrder) ||
        (cartService.partyOrders.value.isNotEmpty &&
            (cartService.partyOrders.value.first.orderItems?.isEmpty ?? true))) {
      return true;
    }

    return false;
  }

  List<OrderItem> get currentOrderItems {
    if (currentPartySelected.value == -2) {
      final items = <OrderItem>[];
      for (var party in cartService.partyOrders.value) {
        items.addAll(party.orderItems ?? []);
      }
      return items;
    }
    // if (currentPartySelected.value >= 0) {
    return cartService.partyOrders.value[currentPartySelected.value].orderItems ?? <OrderItem>[];
    // } else {
    //   return cartService.items.value;
    // }
  }

  int get numberOfGangs {
    if (currentPartySelected.value == -2) {
      return numberOfGang.value;
    }
    // if (currentPartySelected.value >= 0) {
    return cartService.partyOrders.value[currentPartySelected.value].numberOfGangs;
    // } else {
    //   return cartService.numberOfGang.value;
    // }
  }

  double get currentCartPrice {
    if (currentPartySelected.value == -2) {
      var total = 0.0;
      for (var party in cartService.partyOrders.value) {
        total += party.totalPrice;
      }
      return total;
    }
    // if (currentPartySelected.value >= 0) {
    final partyOrder = cartService.partyOrders.value[currentPartySelected.value];
    return Utils.calculateVoucherPrice(partyOrder.voucher, partyOrder.totalPrice);
    // } else {
    //   var total = 0.0;
    //   for (final food in cartService.items.value) {
    //     total += food.quantity * (food.food?.price ?? 0);
    //   }
    //   return Utils.calculateVoucherPrice(cartService.currentVoucher.value, total);
    // }
  }

  Voucher? get currentVoucher {
    // if (currentPartySelected.value >= 0) {
    return cartService.partyOrders.value[currentPartySelected.value].voucher;
    // } else {
    //   return cartService.currentVoucher.value;
    // }
  }

  void onAddVoucher(Voucher voucher, {int? partyIndex}) {
    // if (currentPartySelected.value >= 0) {
    if (partyIndex != null) {
      cartService.updatePartyVoucher(partyIndex, voucher);
      return;
    }
    cartService.updatePartyVoucher(currentPartySelected.value, voucher);
    // } else {
    //   cartService.currentVoucher.value = voucher;
    // }
  }

  void onClearVoucher({int? partyIndex}) {
    // if (currentPartySelected.value >= 0) {
    if (partyIndex != null) {
      cartService.clearVoucherParty(partyIndex);
      return;
    }
    cartService.clearVoucherParty(currentPartySelected.value);
    // } else {
    //   cartService.currentVoucher.value = null;
    // }
  }

  void onChangeCurrentPartyOrder(int value) {
    if (value == -1) {
      cartService.onCreateNewPartyOrder();
      currentPartySelected.value = cartService.partyOrders.value.length - 1;
      cartService.currentPartyOrder = cartService.partyOrders.value.length - 1;
    } else if (value == -2) {
      var gang = 0;
      for (final party in cartService.partyOrders.value) {
        gang = max(party.numberOfGangs, gang);
      }
      numberOfGang.value = gang;
      currentPartySelected.value = -2;
      cartService.currentPartyOrder = 0;
    } else {
      currentPartySelected.value = value;
      cartService.currentPartyOrder = value;
    }
  }

  void onRemovePartyIndex(int partyIndex) {
    if (currentPartySelected.value == partyIndex) {
      currentPartySelected.value = -2;
    } else if (currentPartySelected.value > 0) {
      currentPartySelected.value -= 1;
    }
    cartService.onRemovePartyOrder(partyIndex);
    Get.back();
  }

  void updateQuantityCart(OrderItem item, int quantity, int gangIndex) {
    // if (currentPartySelected.value >= 0) {
    if (currentPartySelected.value == -2) {
      cartService.updateQuantityPartyItem(item.partyIndex, item, quantity, gangIndex);
    } else {
      cartService.updateQuantityPartyItem(currentPartySelected.value, item, quantity, gangIndex);
    }
    // } else {
    //   cartService.updateQuantityCart(item, quantity);
    // }
  }

  void removeItemInOrder(OrderItem item) {
    // if (currentPartySelected.value >= 0) {
    if (currentPartySelected.value == -2) {
      cartService.removeItemInPartyOrder(item.partyIndex, item);
    } else {
      cartService.removeItemInPartyOrder(currentPartySelected.value, item);
    }
    // } else {
    //   cartService.removeItemInOrder(item);
    // }
  }

  void updateCartItemNote(OrderItem item, String note) {
    if (currentPartySelected.value == -2) {
      cartService.updatePartyCartItemNote(item.partyIndex, item, note);
    } else {
      cartService.updatePartyCartItemNote(currentPartySelected.value, item, note);
    }
    // if (currentPartySelected.value >= 0) {
    // cartService.updatePartyCartItemNote(currentPartySelected.value, item, note);
    // } else {
    //   cartService.updateCartItemNote(item, note);
    // }
  }

  // void onRemoveGangIndexOfCartItem(OrderItem item) {
  // if (currentPartySelected.value >= 0) {
  // cartService.onRemoveGangIndexOfPartyCartItem(currentPartySelected.value, item);
  // } else {
  //   cartService.onRemoveGangIndexOfCartItem(item);
  // }
  // }

  void onCreateGang() {
    if (currentPartySelected.value == -2) {
      cartService.onPartyCreateGang(0);
      numberOfGang.value += 1;
    } else {
      cartService.onPartyCreateGang(currentPartySelected.value);
    }
    // if (currentPartySelected.value >= 0) {
    // } else {
    //   cartService.onCreateNewGang();
    // }
  }

  void onRemoveGang(int gang) {
    if (currentPartySelected.value == -2) {
      cartService.onRemoveGangIndexInAllParty(gang);
    } else {
      cartService.onRemoveGangInParty(currentPartySelected.value, gang);
    }
    // if (currentPartySelected.value >= 0) {
    // cartService.onRemoveGangInParty(currentPartySelected.value, gang);
    // } else {
    //   cartService.onRemoveGang(gang);
    // }
  }

  /// Lên đơn
  Future<void> onPlaceOrder() async {
    if (accountService.myAccount?.role == USER_ROLE.STAFF && accountService.myAccount?.checkInTime == null) {
      DialogUtils.showInfoErrorDialog(content: 'not_checkin_error'.tr);
      return;
    }

    isLoading.value = true;
    showLoading();
    try {
      final result = await orderRepository.onPlaceOrder(
        cartService.partyOrders.value,
        tableNumber: parameter.tableNumber.toString(),
        bondNumber: (accountService.myAccount?.numberOfOrder ?? 0) + 1,
      );
      isLoading.value = false;
      dissmissLoading();
      if (result != null) {
        await printerService.onStartPrint(result);
        cartService.partyOrders.value = [];
        currentPartySelected.value = -2;
        cartService.currentPartyOrder = -2;
        await DialogUtils.showSuccessDialog(content: "create_order_success".tr);
        Get.back(result: result);
      } else {
        DialogUtils.showInfoErrorDialog(content: "create_order_fail".tr);
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
      dissmissLoading();
      DialogUtils.showInfoErrorDialog(content: "create_order_fail".tr);
    }
  }
}
