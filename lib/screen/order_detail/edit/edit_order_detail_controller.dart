import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_parameter.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_response.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class EditOrderDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  final EditOrderDetailParameter parameter;
  final IOrderRepository orderRepository;
  late FoodOrder originalOrder;
  late Rx<FoodOrder?> foodOrder = Rx(null);
  final newPartyOrder = Rx<PartyOrder?>(null);
  final currentPartyOrder = Rx<PartyOrder?>(null);
  late final tabController = TabController(length: 2, vsync: this);
  final currentTab = 0.obs;
  final currentPartyIndex = 0.obs;
  List<String> tabItems = ['Edit', 'Chuyển bàn'];

  final selectOrderItems = RxList<String>([]);

  EditOrderDetailController({
    required this.parameter,
    required this.orderRepository,
  });

  @override
  void onClose() {
    selectOrderItems.close();
    currentPartyIndex.close();
    tabController.dispose();
    currentTab.close();
    foodOrder.close();
    currentPartyOrder.close();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    onInitOrderData();
  }

  void onBack() {
    Get.back(result: EditOrderResponse(type: EditType.UPDATE, orignalTable: parameter.foodOrder.tableNumber ?? ''));
  }

  Future<void> onInitOrderData() async {
    try {
      final order = parameter.foodOrder.copyWith(
          partyOrders: parameter.foodOrder.partyOrders
              ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
              .toList());

      if ((order.partyOrders?.length ?? 1) > 1) {
        final first = order.partyOrders!.removeAt(0);
        order.partyOrders!.add(first);
      }
      originalOrder = order.copyWith();
      renewOrder();
      onUpdateCurrentPartyOrder();
    } catch (e) {
      dissmissLoading();
      await DialogUtils.showInfoErrorDialog(content: 'Vui lòng thử lại');
      Get.back();
    }
  }

  void onChangePartyIndex(int partyIndex) {
    if (partyIndex == -1) {
      final newPartyIndex = foodOrder.value?.partyOrders?.length ?? 0;
      if (newPartyOrder.value == null) {
        newPartyOrder.value = PartyOrder(partyNumber: foodOrder.value?.partyOrders?.length ?? 0);
      }
      currentPartyIndex.value = newPartyIndex;
      return;
    }
    if (currentPartyIndex.value == partyIndex) return;
    currentPartyIndex.value = partyIndex;
    renewOrder();
    if (partyIndex == newPartyOrder.value?.partyNumber) {
      currentPartyOrder.value = newPartyOrder.value;
      return;
    }
    onUpdateCurrentPartyOrder();
  }

  void onUpdateCurrentPartyOrder() {
    final partyOrder = foodOrder.value!.partyOrders![currentPartyIndex.value];
    final maxGang = partyOrder.orderItems?.fold<int?>(null, (a, b) {
      if (b.sortOder == null) {
        return a;
      }
      if (a == null) {
        return b.sortOder;
      } else {
        return (b.sortOder ?? 0) > a ? b.sortOder : a;
      }
    });
    currentPartyOrder.value = partyOrder.copyWith(
      orderItems: partyOrder.orderItems?.map((e) => e.copyWith()).toList(),
      numberOfGangs: maxGang,
    );
  }

  void onRemoveGangIndex(int gangIndex) {
    final numberGang = currentPartyOrder.value?.numberOfGangs ?? 0;
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    for (var i = 0; i < list.length; i++) {
      if (list[i].sortOder == gangIndex) {
        list[i].sortOder = null;
      } else if (list[i].sortOder != null && (list[i].sortOder ?? 0) > gangIndex) {
        list[i].sortOder = (list[i].sortOder ?? 1) - 1;
      }
    }
    currentPartyOrder.value =
        currentPartyOrder.value!.copyWith(numberOfGangs: numberGang > 0 ? numberGang - 1 : 0, orderItems: list);
  }

  void onAddNewGang() {
    final numberGang = currentPartyOrder.value?.numberOfGangs ?? 0;
    currentPartyOrder.value = currentPartyOrder.value!.copyWith(numberOfGangs: numberGang + 1);
  }

  void onAddOrderToGang(int gangIndex, List<OrderItem> orderItems) {
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    for (final item in orderItems) {
      final index = findOrderItemInList(list, item);
      if (index != -1) {
        list[index].sortOder = gangIndex;
      }
    }

    currentPartyOrder.value = currentPartyOrder.value?.copyWith(orderItems: list);
  }

  void addFoodToPartyOrder(List<OrderItem> orderItems) {
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    for (final item in orderItems) {
      final index = findOrderItemInList(list, item);
      if (index != -1) {
        list[index].quantity += item.quantity;
      } else {
        list.add(item);
      }
    }

    currentPartyOrder.value = currentPartyOrder.value?.copyWith(orderItems: list);
  }

  void onRemoveOrderItemGang(OrderItem item) {
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    final index = findOrderItemInList(list, item);
    if (index != -1) {
      list[index].sortOder = null;
    }

    currentPartyOrder.value = currentPartyOrder.value?.copyWith(orderItems: list);
  }

  void onRemoveItem(OrderItem item) {
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    final index = findOrderItemInList(list, item);
    if (index != -1) {
      list.removeAt(index);
    }

    currentPartyOrder.value = currentPartyOrder.value?.copyWith(orderItems: list);
  }

  int findOrderItemInList(List<OrderItem> list, OrderItem item) => list.indexWhere((element) =>
      element.food?.foodId == item.food?.foodId ||
      (element.foodId != null && item.foodId != null && element.foodId == item.foodId) ||
      (item.orderItemId != null && element.orderItemId != null && item.orderItemId == element.orderItemId));

  void onChangeTab(int tab) {
    currentTab.value = tab;
    selectOrderItems.value = [];
  }

  void onAddItemToSelect(bool isSelected, OrderItem orderItem) {
    if (isSelected) {
      selectOrderItems.remove(orderItem.orderItemId);
    } else {
      selectOrderItems.add(orderItem.orderItemId ?? '');
    }
    selectOrderItems.refresh();
  }

  void onUpdateAllOrderItem(bool isSelected, List<OrderItem> orderItems) {
    if (isSelected) {
      selectOrderItems.value = [];
    } else {
      selectOrderItems.value = orderItems.map((e) => e.orderItemId ?? '').toList();
    }
  }

  void updateQuantityList(int partyIndex, OrderItem item, int quantity) {
    foodOrder.update((val) {
      final index = val?.partyOrders?[partyIndex].orderItems
              ?.indexWhere((element) => element.food?.foodId == item.food?.foodId) ??
          -1;
      if (index != -1) {
        val?.partyOrders?[partyIndex].orderItems?[index].quantity = quantity;
      }
    });
  }

  void onMoveOrderToOtherTable(TableModels tableModels) async {
    showLoading();
    try {
      final result = await orderRepository.onChangeTableOfOrder(foodOrder.value!, tableModels);
      if (result) {
        dissmissLoading();
        await DialogUtils.showSuccessDialog(content: 'Đổi sang bàn ${tableModels.tableNumber} thành công');
        Get.back(
            result: EditOrderResponse(
                type: EditType.CHANGE_TABLE,
                orignalTable: foodOrder.value!.tableNumber ?? '',
                targetTable: tableModels.tableNumber ?? ''));
      } else {
        dissmissLoading();
      }
    } catch (e) {
      DialogUtils.showSuccessDialog(content: 'Đổi bàn thất bại');
      dissmissLoading();
      print(e);
    }
  }

  void onMovePartyToOtherTable(TableModels targetTableNumber) async {
    try {
      showLoading();
      final res = await orderRepository.onChangeOrderItemToOtherTable(foodOrder.value!.orderId ?? '',
          foodOrder.value!.partyOrders![currentPartyIndex.value], selectOrderItems, targetTableNumber);
      if (res) {
        dissmissLoading();
        await DialogUtils.showSuccessDialog(
            content: 'Các món ăn đã chuyển sang bàn số $targetTableNumber. Vui lòng kiểm tra lại');
        Get.back(
            result: EditOrderResponse(
                type: EditType.CHANGE_TABLE,
                orignalTable: foodOrder.value!.tableNumber ?? '',
                targetTable: targetTableNumber.tableNumber ?? ''));
      } else {
        dissmissLoading();
        await DialogUtils.showInfoErrorDialog(content: 'Vui lòng thử lại');
      }
    } catch (e) {
      print(e);
      dissmissLoading();
      await DialogUtils.showInfoErrorDialog(content: 'Vui lòng thử lại');
    }
  }

  void onDeleteOrder() async {
    excute(() => orderRepository.onDeleteOrder(foodOrder.value!));
    Get.back();
  }

  void onCompleteOrder() async {
    try {
      final newOrder = foodOrder.value!.copyWith();
      newOrder.partyOrders![currentPartyIndex.value].orderStatus = ORDER_STATUS.DONE;
      final newPartyOrder = newOrder.partyOrders![currentPartyIndex.value];
      // final partyNumber = newPartyOrder.partyNumber == null ? newOrder.partyOrders!.length : newPartyOrder.partyNumber!;
      final isYes = await DialogUtils.showYesNoDialog(title: 'Xác nhận thanh toán đơn hàng');
      if (!isYes) return;
      showLoading();
      final isCompleteOrder =
          newOrder.partyOrders!.where((element) => element.orderStatus == ORDER_STATUS.CREATED).isEmpty;

      if (isCompleteOrder) {
        newOrder.orderStatus = ORDER_STATUS.DONE;
        await Future.wait([
          orderRepository.completeOrder(newOrder.orderId ?? '', newOrder.tableNumber ?? ''),
          orderRepository.completePartyOrder(newPartyOrder.partyOrderId ?? ''),
        ]);
        dissmissLoading();
        await DialogUtils.showSuccessDialog(content: 'Đơn hàng đã được hoàn thành');
        Get.back(result: EditOrderResponse(type: EditType.UPDATE, orignalTable: newOrder.tableNumber ?? ''));
      } else {
        await orderRepository.completePartyOrder(newPartyOrder.partyOrderId ?? '');
        dissmissLoading();
        await DialogUtils.showSuccessDialog(content: 'Xác nhận hoàn thành đơn hàng');
      }
      originalOrder = newOrder;
      foodOrder.value =
          originalOrder.copyWith(partyOrders: originalOrder.partyOrders?.map((e) => e.copyWith()).toList());
    } catch (e) {
      print(e);
    } finally {
      dissmissLoading();
    }
  }

  void renewOrder() {
    foodOrder.value = originalOrder.copyWith(
        partyOrders: originalOrder.partyOrders
            ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
            .toList());
  }

  void updatePartyOrder() {
    if (currentPartyOrder.value == null) return;
    excute(() async {
      final result = await orderRepository.updateListOrderInParty(
          currentPartyOrder.value!,
          foodOrder.value!.partyOrders![currentPartyIndex.value].orderItems ?? <OrderItem>[],
          currentPartyOrder.value?.orderItems ?? <OrderItem>[]);
      if (result.isNotEmpty) {
        final newPartyOrder = currentPartyOrder.value!.copyWith(orderItems: result);
        originalOrder.partyOrders![currentPartyIndex.value] = newPartyOrder;
        renewOrder();
        currentPartyOrder.value = newPartyOrder;
      }
    });
  }
}
