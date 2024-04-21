import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
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
  late FoodOrder originalOrder;
  late Rx<FoodOrder?> foodOrder = Rx(null);
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
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    onInitOrderData();
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
    } catch (e) {
      dissmissLoading();
      await DialogUtils.showInfoErrorDialog(content: 'Vui lòng thử lại');
      Get.back();
    }
  }

  void onChangePartyIndex(int partyIndex) {
    if (currentPartyIndex.value == partyIndex) return;
    currentPartyIndex.value = partyIndex;
    renewOrder();
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
    final order = foodOrder.value!;
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

  void updatePartyOrder() {}
}
