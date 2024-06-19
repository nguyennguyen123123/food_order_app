import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:get/get.dart';

class OrderCartService extends GetxService {
  // final items = Rx<List<OrderItem>>([]);
  final partyOrders = Rx<List<PartyOrder>>([PartyOrder(partyNumber: 0, numberOfGangs: 1)]);
  // final currentVoucher = Rx<Voucher?>(null);
  // final numberOfGang = Rx<int>(1);
  int currentPartyOrder = 0;

  void clearCart() {
    // items.value = [];
    currentPartyOrder = 0;
    partyOrders.value = [PartyOrder(partyNumber: 0, numberOfGangs: 1)];
    // currentVoucher.value = null;
    // numberOfGang.value = 1;
  }

  List<OrderItem> get currentListItems => partyOrders.value[currentPartyOrder].orderItems ?? <OrderItem>[];

  void onAddItemToCart(FoodModel foodModel, int gangIndex) {
    final item =
        OrderItem(food: foodModel, foodId: foodModel.foodId, sortOder: gangIndex, partyIndex: currentPartyOrder);
    // if (currentPartyOrder < 0) {
    //   onAddOrderItem(item);
    // } else {
    onAddItemToPartyOrder(currentPartyOrder, [item]);
    // }
  }

  void onUpdateQuantityItemInCart(int quantity, FoodModel foodModel, int gangIndex) {
    final item = OrderItem(food: foodModel, foodId: foodModel.foodId);
    // if (currentPartyOrder < 0) {
    //   updateQuantityCart(item, quantity);
    // } else {
    updateQuantityPartyItem(currentPartyOrder, item, quantity, gangIndex);
    // }
  }

  // void onAddOrderItem(OrderItem orderItem) {
  //   final index = items.value
  //       .indexWhere((element) => element.foodId == orderItem.foodId || element.food?.foodId == orderItem.food?.foodId);
  //   if (index == -1) {
  //     items.update((val) => val?.add(orderItem));
  //   } else {
  //     items.update((val) => val?[index] = val[index].copyWith(quantity: val[index].quantity + orderItem.quantity));
  //   }
  // }

  void onAddItemToPartyOrder(int indexParty, List<OrderItem> orderItems) {
    final listParty = [...partyOrders.value];
    listParty[indexParty].orderItems = [...(listParty[indexParty].orderItems ?? <OrderItem>[]), ...orderItems];
    partyOrders.value = listParty;
    // final listOrder = [...items.value];
    // for (final item in orderItems) {
    //   final index = listOrder.indexWhere((element) => element.foodId == item.foodId);
    //   if (index != -1) {
    //     if (listOrder[index].quantity == item.quantity) {
    //       listOrder.removeAt(index);
    //     } else {
    //       listOrder[index].quantity = (listOrder[index].quantity) - (item.quantity);
    //     }
    //   }
    // }
    // items.value = listOrder;
  }

  // void onAddVoucher(Voucher voucher) {
  //   currentVoucher.value = voucher;
  // }

  // void onCreateNewGang() {
  //   numberOfGang.value += 1;
  // }

  // void onRemoveGang(int gangIndex) {
  //   numberOfGang.value -= 1;
  //   final list = [...items.value];
  //   for (var i = 0; i < list.length; i++) {
  //     if (list[i].sortOder == gangIndex) {
  //       list[i].sortOder = null;
  //     } else if (list[i].sortOder != null && (list[i].sortOder ?? 0) > gangIndex) {
  //       list[i].sortOder = (list[i].sortOder ?? 1) - 1;
  //     }
  //   }
  //   items.value = list;
  // }

  void onRemoveGangInParty(int partyIndex, int gangIndex) {
    final list = [...(partyOrders.value[partyIndex].orderItems ?? <OrderItem>[])];
    list.removeWhere((element) => element.sortOder == gangIndex);
    for (var i = 0; i < list.length; i++) {
      if (list[i].sortOder > gangIndex) {
        list[i].sortOder = list[i].sortOder - 1;
      }
    }
    partyOrders.value[partyIndex] = partyOrders.value[partyIndex].copyWith(
      numberOfGangs: partyOrders.value[partyIndex].numberOfGangs - 1,
      orderItems: list,
    );
    partyOrders.refresh();
  }

  void onRemoveGangIndexInAllParty(int gangIndex) {
    final partys = [...partyOrders.value];
    for (var i = 0; i < partys.length; i++) {
      final list = [...(partys[i].orderItems ?? <OrderItem>[])];
      list.removeWhere((element) => element.sortOder == gangIndex);
      for (var i = 0; i < list.length; i++) {
        if (list[i].sortOder > gangIndex) {
          list[i].sortOder = list[i].sortOder - 1;
        }
      }
      partys[i].orderItems = list;
    }
    partyOrders.value = partys;
  }

  /// Tạo thêm gang ở party order
  void onCreateNewPartyOrder() {
    partyOrders.update((val) => val?.add(PartyOrder(partyNumber: partyOrders.value.length, numberOfGangs: 1)));
  }

  /// Cập nhật số lượng món ăn trong đơn hàng mà không thuộc party nào
  // void updateQuantityCart(OrderItem item, int quantity) {
  //   items.update((val) {
  //     final index =
  //         val?.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) ??
  //             -1;
  //     if (index != -1) {
  //       if (quantity > 0) {
  //         val?[index].quantity = quantity;
  //       } else {
  //         val?.removeAt(index);
  //       }
  //     }
  //   });
  // }

  /// Cập nhật số lượng món ăn thuộc party trong đơn hàng
  void updateQuantityPartyItem(int partyIndex, OrderItem item, int quantity, int gangIndex) {
    partyOrders.update((val) {
      final items = val?[partyIndex].orderItems ?? <OrderItem>[];
      final index = items.indexWhere((element) =>
          (element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) &&
          element.sortOder == gangIndex);
      if (index != -1) {
        if (quantity > 0) {
          items[index].quantity = quantity;
        } else {
          items.removeAt(index);
        }
        val?[partyIndex].orderItems = items;
      }
    });
  }

  /// Xóa món ăn trong đơn hàng không thuộc party nào
  // void removeItemInOrder(OrderItem item) {
  //   items.update((val) {
  //     final index =
  //         val?.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) ??
  //             -1;
  //     if (index != -1) {
  //       val?.removeAt(index);
  //     }
  //   });
  // }

  /// Xóa món ăn của party trong đơn hàng
  void removeItemInPartyOrder(int partyIndex, OrderItem item) {
    partyOrders.update((val) {
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
  // void updateCartItemNote(OrderItem item, String note) {
  //   items.update((val) {
  //     final index =
  //         val?.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) ??
  //             -1;
  //     if (index != -1) {
  //       val?[index].note = note;
  //     }
  //   });
  // }

  /// Cập nhật note cho món ăn trong party
  void updatePartyCartItemNote(int partyIndex, OrderItem item, String note) {
    partyOrders.update((val) {
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
    partyOrders.update((val) {
      val?[partyIndex].voucher = voucher;
    });
  }

  /// Xóa voucher cho party
  void clearVoucherParty(int partyIndex) {
    partyOrders.update((val) {
      val?[partyIndex].voucher = null;
    });
  }

  /// Xóa party
  void onRemovePartyOrder(int partyIndex) {
    partyOrders.update((val) {
      val?.removeAt(partyIndex);
    });
  }

  /// Thêm mức độ ưu tiên lên món của món ăn trong party hoặc đơn hàng
  void updateOrderItemInCart(int gangIndex, List<OrderItem> orderItems, {int? partyIndex}) {
    if (partyIndex == null) return;
    // if (partyIndex == null) {
    //   final list = [...items.value];
    //   for (final item in orderItems) {
    //     final index = list.indexWhere((element) => element.foodId == item.foodId);
    //     if (index != -1) {
    //       list[index].sortOder = gangIndex;
    //     }
    //   }
    //   items.value = list;
    // } else {
    final list = [...(partyOrders.value[partyIndex].orderItems ?? <OrderItem>[])];
    for (final item in orderItems) {
      final index = list.indexWhere((element) => element.foodId == item.foodId);
      if (index != -1) {
        list[index].sortOder = gangIndex;
      }
    }
    partyOrders.value[partyIndex].orderItems = list;
    partyOrders.refresh();
    // }
  }

  /// Tạo thêm gang trong party
  void onPartyCreateGang(int partyIndex) {
    partyOrders.update((val) {
      val?[partyIndex].numberOfGangs += 1;
    });
  }

  // void onRemoveGangIndexOfCartItem(OrderItem item) {
  //   items.update((val) {
  //     final index =
  //         val?.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId) ??
  //             -1;
  //     if (index != -1) {
  //       val?[index].sortOder = null;
  //     }
  //   });
  // }

  // void onRemoveGangIndexOfPartyCartItem(int partyIndex, OrderItem item) {
  //   partyOrders.update((val) {
  //     final items = val?[partyIndex].orderItems ?? <OrderItem>[];
  //     final index =
  //         items.indexWhere((element) => element.food?.foodId == item.food?.foodId || element.foodId == item.foodId);
  //     if (index != -1) {
  //       items[index].sortOder = null;
  //       val?[partyIndex].orderItems = items;
  //     }
  //   });
  // }

  double get totalCartPrice {
    var total = 0.0;
    // for (final food in items.value) {
    //   total += food.quantity * (food.food?.price ?? 0);
    // }
    for (final party in partyOrders.value) {
      total += party.totalPrice;
    }
    // if (currentVoucher.value != null) {
    //   if (currentVoucher.value?.discountType == DiscountType.amount) {
    //     total -= currentVoucher.value?.discountValue ?? 0;
    //   } else {
    //     total = total * ((currentVoucher.value?.discountValue ?? 100) / 100);
    //   }
    // }
    return total;
  }
}
