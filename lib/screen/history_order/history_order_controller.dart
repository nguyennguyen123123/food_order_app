import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class HistoryOrderController extends GetxController with GetSingleTickerProviderStateMixin {
  final IOrderRepository orderRepository;
  final AccountService accountService;

  HistoryOrderController({
    required this.orderRepository,
    required this.accountService,
  });

  final foodOrderList = Rx<List<FoodOrder>?>(null);
  final orderSelecteIds = Rx<List<String>>([]);
  final currentTab = Rx<int>(0);
  final tab = [Tab(text: 'view'.tr), Tab(text: 'edit'.tr)];
  late final tabCtr = TabController(length: 2, vsync: this);

  int page = 0;
  int limit = LIMIT;

  @override
  void onClose() {
    orderSelecteIds.close();
    foodOrderList.close();
    tabCtr.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  void onChangeTab(int newTab) {
    currentTab.value = newTab;
    orderSelecteIds.value = [];
  }

  Future<void> onRefresh() async {
    final result = await orderRepository.getListFoodOrders(page: page, limit: limit);

    foodOrderList.value = result;
  }

  Future<bool> onLoadMore() async {
    final length = (foodOrderList.value ?? []).length;
    if (length < LIMIT * (page + 1)) return false;
    page += 1;

    final result = await orderRepository.getListFoodOrders(page: page, limit: limit);

    foodOrderList.update((val) => val?.addAll(result));
    if (result.length < limit) return false;
    return true;
  }

  void onRemoveFoodOrder(FoodOrder foodOrder) {
    final index = foodOrderList.value?.indexWhere((element) => element.orderId == foodOrder.orderId) ?? -1;
    if (index != -1) {
      foodOrderList.update((val) => val?.removeAt(index));
    }
  }

  void onUpdateCurrentOrderSelect(bool isSelect, String orderId) {
    if (isSelect) {
      orderSelecteIds.update((val) => val?.add(orderId));
    } else {
      orderSelecteIds.update((val) => val?.remove(orderId));
    }
    orderSelecteIds.refresh();
  }

  Future<void> onDeleteOrder() async {
    if (currentTab.value == 0) {
      excute(() async {
        final result = await orderRepository.onDeletaAll();
        if (result) {
          foodOrderList.value = [];
        }
      });
    } else {
      if (orderSelecteIds.value.isEmpty) return;
      excute(() async {
        final result = await orderRepository.onDeleteListOrder(orderSelecteIds.value);
        if (result) {
          final list = [...foodOrderList.value!];
          list.removeWhere((element) => orderSelecteIds.value.contains(element.orderId));
          foodOrderList.value = list;
        }
      });
    }
  }
}
