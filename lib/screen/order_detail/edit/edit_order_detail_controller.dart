import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
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
  late Rx<FoodOrder> foodOrder;
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
    tabController.dispose();
    currentTab.close();
    foodOrder.close();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    final order = parameter.foodOrder;
    if ((order.partyOrders?.length ?? 1) > 1) {
      final first = order.partyOrders!.removeAt(0);
      order.partyOrders!.add(first);
    }
    foodOrder = Rx(order);
  }

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
    // selectOrderItems.refresh();
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

  void onRemoveItem(int partyIndex, OrderItem item) {
    foodOrder.update((val) {
      final index = val?.partyOrders?[partyIndex].orderItems
              ?.indexWhere((element) => element.food?.foodId == item.food?.foodId) ??
          -1;
      if (index != -1) {
        val?.partyOrders?[partyIndex].orderItems?.removeAt(index);
      }
    });
  }

  void addFoodToPartyOrder(int partyIndex, List<OrderItem> orderItems) {
    final order = foodOrder.value;
    for (final item in orderItems) {
      final orderIndex = order.partyOrders?[partyIndex].orderItems
              ?.indexWhere((element) => element.food?.foodId == item.food?.foodId) ??
          -1;
      if (orderIndex == -1) {
        order.partyOrders?[partyIndex].orderItems?.add(item);
      } else {
        final curItem = order.partyOrders?[partyIndex].orderItems?[orderIndex];
        order.partyOrders?[partyIndex].orderItems?[orderIndex].quantity = (curItem?.quantity ?? 1) + item.quantity;
      }
    }
    foodOrder.value = order;
    foodOrder.refresh();
  }

  void onMoveOrderToOtherTable(TableModels tableModels) async {
    showLoading();
    try {
      final result = await orderRepository.onChangeTableOfOrder(foodOrder.value, tableModels);
      if (result) {
        dissmissLoading();
        await DialogUtils.showSuccessDialog(content: 'Đổi sang bàn ${tableModels.tableNumber} thành công');
        final order = foodOrder.value.copyWith(tableNumber: tableModels.tableNumber.toString());
        Get.back(result: EditOrderResponse(foodOrder: order, type: EditType.CHANGE_WHOLE_ORDER_TABLE));
      } else {
        dissmissLoading();
      }
    } catch (e) {
      DialogUtils.showSuccessDialog(content: 'Đổi bàn thất bại');
      dissmissLoading();
      print(e);
    }
  }

  void onMovePartyToOtherTable(TableModels targetTableNumber) {
    orderRepository.onChangeOrderItemToOtherTable(
        foodOrder.value.partyOrders![currentPartyIndex.value], selectOrderItems, targetTableNumber);
  }

  void onDeleteOrder() async {
    excute(() => orderRepository.onDeleteOrder(foodOrder.value));
    Get.back();
  }
}
