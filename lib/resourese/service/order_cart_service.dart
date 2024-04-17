import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:get/get.dart';

class OrderCartService extends GetxService {
  final items = Rx<List<OrderItem>>([]);
  final partyOrders = Rx<List<PartyOrder>>([]);
  final currentVoucher = Rx<Voucher?>(null);
  final numberOfGang = Rx<int>(0);

  void clearCart() {
    items.value = [];
    partyOrders.value = [];
    currentVoucher.value = null;
    numberOfGang.value = 0;
  }

  void onAddOrderItem(OrderItem orderItem) {
    final index = items.value
        .indexWhere((element) => element.foodId == orderItem.foodId || element.food?.foodId == orderItem.food?.foodId);
    if (index == -1) {
      items.update((val) => val?.add(orderItem));
    } else {
      items.update((val) => val?[index] = val[index].copyWith(quantity: val[index].quantity + orderItem.quantity));
    }
  }

  void onAddItemToPartyOrder(int indexParty, List<OrderItem> orderItems) {
    final listParty = [...partyOrders.value];
    listParty[indexParty].orderItems = [...(listParty[indexParty].orderItems ?? <OrderItem>[]), ...orderItems];
    partyOrders.value = listParty;
    final listOrder = [...items.value];
    for (final item in orderItems) {
      final index = listOrder.indexWhere((element) => element.foodId == item.foodId);
      if (index != -1) {
        if (listOrder[index].quantity == item.quantity) {
          listOrder.removeAt(index);
        } else {
          listOrder[index].quantity = (listOrder[index].quantity) - (item.quantity);
        }
      }
    }
    items.value = listOrder;
  }

  void onAddVoucher(Voucher voucher) {
    currentVoucher.value = voucher;
  }

  void onCreateNewGang() {
    numberOfGang.value += 1;
  }

  void onRemoveGang(int gangIndex) {
    numberOfGang.value -= 1;
    final list = [...items.value];
    for (var i = 0; i < list.length; i++) {
      if (list[i].sortOder == gangIndex) {
        list[i].sortOder = null;
      } else if (list[i].sortOder != null && (list[i].sortOder ?? 0) > gangIndex) {
        list[i].sortOder = (list[i].sortOder ?? 1) - 1;
      }
    }
    items.value = list;
  }

  void onRemoveGangInParty(int partyIndex, int gangIndex) {
    // partyOrders.update((val) {
    //   final list = [...(val?[partyIndex].orderItems ?? <OrderItem>[])];
    //   for (var i = 0; i < list.length; i++) {
    //   if (list[i].sortOder == gangIndex) {
    //     list[i].sortOder = null;
    //   } else if (list[i].sortOder != null && (list[i].sortOder ?? 0) > gangIndex) {
    //     list[i].sortOder = (list[i].sortOder ?? 1) - 1;
    //   }
    // }

    // });
    final list = [...(partyOrders.value[partyIndex].orderItems ?? <OrderItem>[])];
    for (var i = 0; i < list.length; i++) {
      if (list[i].sortOder == gangIndex) {
        list[i].sortOder = null;
      } else if (list[i].sortOder != null && (list[i].sortOder ?? 0) > gangIndex) {
        list[i].sortOder = (list[i].sortOder ?? 1) - 1;
      }
    }
    partyOrders.value[partyIndex] = partyOrders.value[partyIndex].copyWith(
      numberOfGangs: partyOrders.value[partyIndex].numberOfGangs - 1,
      orderItems: list,
    );
  }

  double get totalCartPrice {
    var total = 0.0;
    for (final food in items.value) {
      total += food.quantity * (food.food?.price ?? 0);
    }
    for (final party in partyOrders.value) {
      total += party.totalPrice;
    }
    if (currentVoucher.value != null) {
      if (currentVoucher.value?.discountType == DiscountType.amount) {
        total -= currentVoucher.value?.discountValue ?? 0;
      } else {
        total = total * ((currentVoucher.value?.discountValue ?? 100) / 100);
      }
    }
    return total;
  }
}
