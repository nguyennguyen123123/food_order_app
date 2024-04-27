import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/printer_service.dart';
import 'package:food_delivery_app/resourese/summarize/isummarize_repository.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_detail_parameter.dart';
import 'package:food_delivery_app/screen/order_detail/edit/edit_order_response.dart';
import 'package:food_delivery_app/screen/table/table_controller.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class EditOrderDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  final EditOrderDetailParameter parameter;
  final IOrderRepository orderRepository;
  final ITableRepository tableRepository;
  final ISummarizeRepository summarizeRepository;
  final AccountService accountService;
  final PrinterService printerService;

  EditOrderDetailController({
    required this.parameter,
    required this.tableRepository,
    required this.orderRepository,
    required this.accountService,
    required this.summarizeRepository,
    required this.printerService,
  });

  late FoodOrder originalOrder;
  late Rx<FoodOrder?> foodOrder = Rx(null);
  late Rx<FoodOrder?> newFoodOrder = Rx(null);
  // late PartyOrder? newParty = null;
  final currentPartyOrder = Rx<PartyOrder?>(null);
  late final tabController = TabController(length: 2, vsync: this);
  final currentTab = 0.obs;
  final currentPartyIndex = 0.obs;
  List<String> tabItems = ['edit'.tr, 'move_table'.tr];

  final selectOrderItems = RxList<String>([]);

  bool get isAdmin => accountService.myAccount?.role == USER_ROLE.ADMIN;

  bool get hasCheckin {
    if (isAdmin) {
      return true;
    } else {
      return accountService.myAccount?.checkInTime != null;
    }
  }

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

  void onBack() async {
    if (hasCheckin) {
      final result =
          await DialogUtils.showYesNoDialog(title: 'do_you_want_to_update_the_order_with_the_latest_data'.tr + '?');
      if (result == true) {
        final result = await updatePartyOrder();
        if (result == true) return;
      }
    }
    Get.back(result: EditOrderResponse(type: EditType.UPDATE, orignalTable: parameter.foodOrder.tableNumber ?? ''));
  }

  List<PartyOrder> _mapPartyAndOrderItem(List<PartyOrder> partys) => partys
      .asMap()
      .entries
      .map((e) => e.value.copyWith(
          orderItems: e.value.orderItems
              ?.map((item) => item.copyWith(partyIndex: e.key, partyOrderStaus: e.value.orderStatus))
              .toList()))
      .toList();

  Future<void> onInitOrderData() async {
    try {
      final listPartys = await orderRepository.getListPartyOrderOfOrder(parameter.foodOrder.orderId ?? '');
      final newPartyOrders = listPartys.isNotEmpty
          ? _mapPartyAndOrderItem(listPartys)
          : _mapPartyAndOrderItem(parameter.foodOrder.partyOrders ?? <PartyOrder>[]);
      newPartyOrders.sort((a, b) => (a.partyNumber ?? 0).compareTo(b.partyNumber ?? 0));
      final order = parameter.foodOrder.copyWith(partyOrders: newPartyOrders);
      originalOrder = order.copyWith(
          partyOrders: order.partyOrders
              ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((item) => item.copyWith()).toList()))
              .toList());
      foodOrder.value = originalOrder.copyWith(
          partyOrders: originalOrder.partyOrders
              ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
              .toList());
      newFoodOrder.value = originalOrder.copyWith(
          partyOrders: originalOrder.partyOrders
              ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
              .toList());
      onUpdateCurrentPartyOrder();
    } catch (e) {
      dissmissLoading();
      await DialogUtils.showInfoErrorDialog(content: 'try_again'.tr);
      Get.back();
    }
  }

  void onChangePartyIndex(int partyIndex) {
    if (partyIndex == -1) {
      /// Tạo thêm một part order mới
      var newPartyIndex = 0;
      for (final partyOrder in newFoodOrder.value?.partyOrders ?? <PartyOrder>[]) {
        newPartyIndex = max(newPartyIndex, partyOrder.partyNumber ?? 0);
      }
      newPartyIndex += 1;
      final newParty = PartyOrder(partyNumber: newPartyIndex, orderItems: [], orderStatus: ORDER_STATUS.CREATED);
      newFoodOrder.value!.partyOrders!.add(newParty);
      currentPartyOrder.value = newParty;
      currentPartyIndex.value = (newFoodOrder.value!.partyOrders?.length ?? 1) - 1;
      return;
    }

    if (currentPartyIndex.value == partyIndex) return;
    currentPartyIndex.value = partyIndex;
    if (partyIndex == -2) {
      _createAllesPartyOrder();
      return;
    }
    if (currentTab.value == 0) {
      onUpdateCurrentPartyOrder();
    } else {
      selectOrderItems.value = [];
      onChangeToCurrentFoodPartyOrder();
    }
  }

  void onUpdateCurrentPartyOrder() {
    final partyOrder = newFoodOrder.value!.partyOrders![currentPartyIndex.value];
    final maxGang = partyOrder.orderItems?.fold<int?>(null, (a, b) {
      if (a == null) {
        return b.sortOder;
      } else {
        return (b.sortOder) > a ? b.sortOder : a;
      }
    });
    currentPartyOrder.value = partyOrder.copyWith(
      orderItems: partyOrder.orderItems?.map((e) => e.copyWith()).toList(),
      numberOfGangs: maxGang,
    );
  }

  void onChangeToCurrentFoodPartyOrder() {
    final partyOrder = foodOrder.value!.partyOrders![currentPartyIndex.value];
    final maxGang = partyOrder.orderItems?.fold<int?>(null, (a, b) {
      if (a == null) {
        return b.sortOder;
      } else {
        return (b.sortOder) > a ? b.sortOder : a;
      }
    });
    currentPartyOrder.value = partyOrder.copyWith(
      orderItems: partyOrder.orderItems?.map((e) => e.copyWith()).toList(),
      numberOfGangs: maxGang,
    );
  }

  void onUpdateVoucherOrder(Voucher voucher) {
    currentPartyOrder.value = currentPartyOrder.value!.copyWith(
      voucher: voucher,
      voucherType: voucher.discountType?.toString(),
      voucherPrice: voucher.discountValue,
    );
    if (currentPartyIndex.value != -2) {
      originalOrder.partyOrders![currentPartyIndex.value] =
          originalOrder.partyOrders![currentPartyIndex.value].copyWith(
        voucher: voucher,
        voucherType: voucher.discountType?.toString(),
        voucherPrice: voucher.discountValue,
      );
      foodOrder.value?.partyOrders?[currentPartyIndex.value] =
          foodOrder.value!.partyOrders![currentPartyIndex.value].copyWith(
        voucher: voucher,
        voucherType: voucher.discountType?.toString(),
        voucherPrice: voucher.discountValue,
      );
    }
    updateNewPartyWithCurrentParty();
  }

  void clearVoucherParty() {
    final party = currentPartyOrder.value;
    party?.clearVoucher();
    if (currentPartyIndex.value != -2) {
      originalOrder.partyOrders![currentPartyIndex.value].clearVoucher();
      foodOrder.value!.partyOrders![currentPartyIndex.value].clearVoucher();
    }
    currentPartyOrder.value = party;
    currentPartyOrder.refresh();
    updateNewPartyWithCurrentParty();
  }

  void onRemoveGangIndex(int gangIndex) {
    final numberGang = currentPartyOrder.value?.numberOfGangs ?? 0;
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    list.removeWhere((element) => element.sortOder == gangIndex && element.partyOrderStaus != ORDER_STATUS.DONE);
    for (var i = 0; i < list.length; i++) {
      if ((list[i].sortOder) > gangIndex) {
        list[i].sortOder = (list[i].sortOder) - 1;
      }
    }
    currentPartyOrder.value =
        currentPartyOrder.value!.copyWith(numberOfGangs: numberGang > 0 ? numberGang - 1 : 0, orderItems: list);
    updateNewPartyWithCurrentParty();
  }

  void onAddNewGang() {
    final numberGang = currentPartyOrder.value?.numberOfGangs ?? 0;
    currentPartyOrder.value = currentPartyOrder.value!.copyWith(numberOfGangs: numberGang + 1);
    updateNewPartyWithCurrentParty();
  }

  void addFoodToPartyOrder(FoodModel food, int gangIndex, {int? quantity}) {
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    final item = OrderItem(
        food: food,
        foodId: food.foodId,
        quantity: quantity ?? 1,
        partyIndex: currentPartyIndex.value == -2 ? 0 : currentPartyIndex.value);
    final index = findOrderItemInList(list, item, gangIndex: gangIndex);
    if (index != -1) {
      list[index].sortOder = gangIndex;
      if (quantity != null) {
        list[index].quantity = quantity;
      } else {
        list[index].quantity += item.quantity;
      }
    } else {
      list.add(item.copyWith(sortOder: gangIndex));
    }

    currentPartyOrder.value = currentPartyOrder.value?.copyWith(orderItems: list);
    updateNewPartyWithCurrentParty(item: item);
  }

  void updateQuantityList(int partyIndex, OrderItem item, int quantity, int gangIndex) {
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    final index = findOrderItemInList(list, item, gangIndex: gangIndex);
    if (index != -1) {
      list[index].quantity = quantity;
    }

    currentPartyOrder.value = currentPartyOrder.value?.copyWith(orderItems: list);
    updateNewPartyWithCurrentParty(item: item);
  }

  void onRemoveItem(OrderItem item) {
    final list = currentPartyOrder.value?.orderItems ?? <OrderItem>[];
    final index = findOrderItemInList(list, item, gangIndex: item.sortOder);
    if (index != -1) {
      list.removeAt(index);
    }

    currentPartyOrder.value = currentPartyOrder.value?.copyWith(orderItems: list);
    updateNewPartyWithCurrentParty(item: item.copyWith(quantity: 0));
  }

  int findOrderItemInList(List<OrderItem> list, OrderItem item, {int? gangIndex}) => list.indexWhere((element) {
        var query = (element.food?.foodId == item.food?.foodId ||
            (element.foodId != null && item.foodId != null && element.foodId == item.foodId) ||
            (item.orderItemId != null && element.orderItemId != null && item.orderItemId == element.orderItemId));
        if (gangIndex != null) {
          query = query && gangIndex == element.sortOder;
        }
        return query;
      });

  void updateNewPartyWithCurrentParty({OrderItem? item}) {
    if (currentPartyIndex.value == -2) {
      if (item != null) {
        for (var i = 0; i < newFoodOrder.value!.partyOrders!.length; i++) {
          final partyOrder = newFoodOrder.value!.partyOrders![i];
          final index = partyOrder.orderItems?.indexWhere((element) =>
                  element.partyIndex == item.partyIndex &&
                  element.sortOder == item.sortOder &&
                  element.food?.foodId == item.food?.foodId) ??
              -1;
          if (index != -1) {
            if (item.quantity == 0) {
              newFoodOrder.value!.partyOrders![i].orderItems!.removeAt(index);
            } else {
              newFoodOrder.value!.partyOrders![i].orderItems![index] = item;
            }
            return;
          }
        }
      }
      return;
    }
    if (currentPartyOrder.value != null &&
        currentPartyIndex.value != -2 &&
        currentPartyIndex.value < newFoodOrder.value!.partyOrders!.length) {
      newFoodOrder.value!.partyOrders![currentPartyIndex.value] = currentPartyOrder.value!;
    }
  }

  void onChangeTab(int tab) {
    if (tab == currentTab.value) return;
    currentTab.value = tab;

    if (tab == 0) {
      if (currentPartyIndex.value == -2) {
        _createAllesPartyOrder();
      } else {
        onUpdateCurrentPartyOrder();
      }
    } else {
      if (currentPartyIndex.value == -2) {
        _createAllesFoodPartyOrder();
      } else {
        onChangeToCurrentFoodPartyOrder();
      }
    }

    selectOrderItems.value = [];
  }

  void _createAllesPartyOrder() {
    final orderItems = <OrderItem>[];
    var numberOfGang = 0;
    for (final party in newFoodOrder.value!.partyOrders!) {
      final items = (party.orderItems ?? []).map((e) => e.copyWith()).toList();
      orderItems.addAll(items);
      final maxGang = items.fold<int?>(null, (a, b) {
            if (a == null) {
              return b.sortOder;
            } else {
              return (b.sortOder) > a ? b.sortOder : a;
            }
          }) ??
          0;
      numberOfGang = max(numberOfGang, maxGang);
    }

    currentPartyOrder.value = PartyOrder(numberOfGangs: numberOfGang, orderItems: orderItems);
  }

  void _createAllesFoodPartyOrder() {
    final orderItems = <OrderItem>[];
    var numberOfGang = 0;
    for (final party in foodOrder.value!.partyOrders!) {
      final items = (party.orderItems ?? []).map((e) => e.copyWith()).toList();
      orderItems.addAll(items);
      final maxGang = items.fold<int?>(null, (a, b) {
            if (a == null) {
              return b.sortOder;
            } else {
              return (b.sortOder) > a ? b.sortOder : a;
            }
          }) ??
          0;
      numberOfGang = max(numberOfGang, maxGang);
    }

    currentPartyOrder.value = PartyOrder(numberOfGangs: numberOfGang, orderItems: orderItems);
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
      if (currentPartyIndex.value == -2) {
        final items = [...orderItems];
        items.removeWhere((element) => element.partyOrderStaus == ORDER_STATUS.CREATED);
        selectOrderItems.value = items.map((e) => e.orderItemId ?? '').toList();
      } else {
        selectOrderItems.value = orderItems.map((e) => e.orderItemId ?? '').toList();
      }
    }
  }

  void onMoveOrderToOtherTable(TableModels tableModels) async {
    showLoading();
    try {
      final result = await orderRepository.onChangeTableOfOrder(foodOrder.value!, tableModels);
      if (result) {
        dissmissLoading();
        await DialogUtils.showSuccessDialog(
            content: 'move_table_sucess'.trParams({'number': '${tableModels.tableNumber}'}));
        Get.back(
            result: EditOrderResponse(
                type: EditType.CHANGE_TABLE,
                orignalTable: foodOrder.value!.tableNumber ?? '',
                targetTable: tableModels.tableNumber ?? ''));
      } else {
        dissmissLoading();
      }
    } catch (e) {
      DialogUtils.showSuccessDialog(content: 'move_table_fail'.tr);
      dissmissLoading();
      print(e);
    }
  }

  void onMovePartyToOtherTable(TableModels targetTableNumber) async {
    try {
      showLoading();
      if (currentPartyIndex.value == -2) {
        final partys = originalOrder.partyOrders
                ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
                .toList() ??
            <PartyOrder>[];
        originalOrder.partyOrders = await Future.wait(partys.map((party) async {
          if (party.orderStatus == ORDER_STATUS.DONE) return party;
          final partyOrderItemIds = party.orderItems?.map((e) => e.orderItemId).toList() ?? <String>[];
          final selectOrderIds = selectOrderItems.where((e) => partyOrderItemIds.contains(e)).toList();
          if (selectOrderIds.isNotEmpty) {
            final result = await orderRepository.onChangeOrderItemToOtherTable(
                foodOrder.value!.orderId ?? '', party, selectOrderIds, targetTableNumber);
            if (result) {
              party.orderItems?.removeWhere((element) => selectOrderIds.contains(element.orderItemId));
            }
          }
          return party;
        }));
        final tableController = Get.find<TableControlller>();
        tableController.onRefreshTable(targetTableNumber.tableNumber ?? '');
        renewOrder();
        if (newFoodOrder.value != null) {
          for (var i = 0; i < (newFoodOrder.value!.partyOrders?.length ?? 0); i++) {
            newFoodOrder.value!.partyOrders![i].orderItems?.removeWhere(
                (element) => element.orderItemId != null && selectOrderItems.contains(element.orderItemId ?? ''));
          }
        }
        _createAllesPartyOrder();
        dissmissLoading();
        DialogUtils.showSuccessDialog(
            content: 'move_food_to_table'.trParams({'number': '${targetTableNumber.tableNumber}'}));
      } else {
        final res = await orderRepository.onChangeOrderItemToOtherTable(foodOrder.value!.orderId ?? '',
            foodOrder.value!.partyOrders![currentPartyIndex.value], selectOrderItems, targetTableNumber);
        dissmissLoading();
        if (res) {
          await DialogUtils.showSuccessDialog(
              content: 'move_food_to_table'.trParams({'number': '${targetTableNumber.tableNumber}'}));
          final tableController = Get.find<TableControlller>();
          tableController.onRefreshTable(targetTableNumber.tableNumber ?? '');
          final newPartyOrder = originalOrder.partyOrders![currentPartyIndex.value];
          newPartyOrder.orderItems?.removeWhere((element) => selectOrderItems.contains(element.orderItemId ?? ''));
          originalOrder.partyOrders?[currentPartyIndex.value] = newPartyOrder;
          renewOrder();
          if (newFoodOrder.value != null) {
            newFoodOrder.value!.partyOrders![currentPartyIndex.value].orderItems!
                .removeWhere((element) => selectOrderItems.contains(element.orderItemId ?? ''));
          }
        } else {
          await DialogUtils.showInfoErrorDialog(content: 'try_again'.tr);
        }
      }
      selectOrderItems.value = [];
    } catch (e) {
      print(e);
      dissmissLoading();
      await DialogUtils.showInfoErrorDialog(content: 'try_again'.tr);
    }
  }

  void onDeleteOrder() async {
    excute(() => orderRepository.onDeleteOrder(foodOrder.value!));
    Get.back();
  }

  void onCompleteOrder() async {
    try {
      final isYes = await DialogUtils.showYesNoDialog(title: 'finish_payment_order'.tr);
      if (!isYes) return;
      showLoading();
      final newOrder = foodOrder.value!.copyWith();
      if (currentPartyIndex.value == -2) {
        /// Cập nhật trạng thái của cả order thành hoàn thành
        var totalPrice = 0.0;
        var total = 0.0;
        for (var i = 0; i < (newOrder.partyOrders?.length ?? 0); i++) {
          if (newOrder.partyOrders![i].orderStatus == ORDER_STATUS.CREATED) {
            totalPrice += newOrder.partyOrders?[i].totalPrice ?? 0.0;
          }
          total += newOrder.partyOrders?[i].totalPrice ?? 0.0;
          newOrder.partyOrders![i] = newOrder.partyOrders![i].copyWith(orderStatus: ORDER_STATUS.DONE);
        }
        newOrder.orderStatus = ORDER_STATUS.DONE;
        await Future.wait([
          summarizeRepository.increaseTodayRecord(total),
          accountService.onUpdateTotalPriceInAccount(totalPrice),
          orderRepository.completeOrder(newOrder.orderId ?? '', newOrder.tableNumber ?? ''),
          orderRepository.completeListPartyOrder(newOrder.partyOrders?.map((e) => e.partyOrderId ?? '').toList() ?? []),
        ]);
        dissmissLoading();
        await _showCompleteOrder(totalPrice);
        Get.back(result: EditOrderResponse(type: EditType.UPDATE, orignalTable: newOrder.tableNumber ?? ''));
      } else {
        /// Cập nhật trạng thái của một party thành hoàn thành
        newOrder.partyOrders![currentPartyIndex.value].orderStatus = ORDER_STATUS.DONE;
        newOrder.partyOrders![currentPartyIndex.value].orderItems = newOrder
            .partyOrders![currentPartyIndex.value].orderItems
            ?.map((e) => e.copyWith(partyOrderStaus: ORDER_STATUS.DONE))
            .toList();
        final newPartyOrder = newOrder.partyOrders![currentPartyIndex.value];

        final isCompleteOrder =
            newOrder.partyOrders!.where((element) => element.orderStatus == ORDER_STATUS.CREATED).isEmpty;

        if (isCompleteOrder) {
          /// Trường hợp order còn một party là hoàn thành
          var total = 0.0;
          for (var i = 0; i < (newOrder.partyOrders?.length ?? 0); i++) {
            total += newOrder.partyOrders?[i].totalPrice ?? 0.0;
          }
          newOrder.orderStatus = ORDER_STATUS.DONE;
          await Future.wait([
            summarizeRepository.increaseTodayRecord(total),
            accountService.onUpdateTotalPriceInAccount(newPartyOrder.totalPrice),
            orderRepository.completeOrder(newOrder.orderId ?? '', newOrder.tableNumber ?? ''),
            orderRepository.completePartyOrder(newPartyOrder.partyOrderId ?? ''),
          ]);
          dissmissLoading();
          await _showCompleteOrder(newPartyOrder.totalPrice);
          Get.back(result: EditOrderResponse(type: EditType.UPDATE, orignalTable: newOrder.tableNumber ?? ''));
        } else {
          /// Trường hợp order có nhiều hơn một party chưa hoàn thành
          await Future.wait([
            orderRepository.completePartyOrder(newPartyOrder.partyOrderId ?? ''),
            accountService.onUpdateTotalPriceInAccount(newPartyOrder.totalPrice)
          ]);

          dissmissLoading();
          await _showCompleteOrder(newPartyOrder.totalPrice);
          final index = newFoodOrder.value?.partyOrders
                  ?.indexWhere((element) => element.partyOrderId == newPartyOrder.partyOrderId) ??
              -1;
          if (index != -1) {
            newFoodOrder.value!.partyOrders![index] = newPartyOrder;
          }
        }
        if (currentPartyIndex.value != -2 && currentTab.value == 0) {
          currentPartyOrder.value = originalOrder.partyOrders![currentPartyIndex.value];
        }
        originalOrder = newOrder;
        renewOrder();
      }
    } catch (e) {
      print(e);
    } finally {
      dissmissLoading();
    }
  }

  Future<void> _showCompleteOrder(double price) => DialogUtils.showSuccessDialog(
      content: 'complete_order'.tr +
          '\n' +
          'confirm_complete_order_description'.trParams({'number': Utils.getCurrency(price)}));

  void renewOrder() {
    foodOrder.value = originalOrder.copyWith(
        partyOrders: originalOrder.partyOrders
            ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
            .toList());
  }

  Future<bool?> updatePartyOrder() async {
    if (currentPartyOrder.value == null) return null;
    final result = await excute<bool>(() async {
      final partys = newFoodOrder.value?.partyOrders ?? <PartyOrder>[];

      var result = await Future.wait(partys.map((party) async {
        if (party.orderStatus == ORDER_STATUS.DONE) return party;
        if (party.partyOrderId == null) {
          final newParty = await orderRepository.uploadNewPartyOrder(foodOrder.value!.orderId ?? '', party);
          return newParty;
        } else {
          final originalPartyIndex =
              foodOrder.value!.partyOrders?.indexWhere((element) => element.partyOrderId == party.partyOrderId) ?? -1;
          if (originalPartyIndex != -1) {
            final result = await orderRepository.updateListOrderInParty(
                party,
                foodOrder.value!.partyOrders![originalPartyIndex].orderItems ?? <OrderItem>[],
                party.orderItems ?? <OrderItem>[]);
            if (result.isNotEmpty) {
              party.orderItems = result;
            }
          }
        }
        return party;
      }));
      result.removeWhere((element) => element == null);
      final isEmptyAll = isEmptyAllPartyOrder(result);
      if (isEmptyAll) {
        await tableRepository.updateTableWithOrder(parameter.foodOrder.tableNumber ?? '');
        Get.back(result: EditOrderResponse(type: EditType.UPDATE, orignalTable: parameter.foodOrder.tableNumber ?? ''));
        return true;
      }
      originalOrder = originalOrder.copyWith(partyOrders: result.map((e) => e!.copyWith()).toList());
      foodOrder.value = originalOrder.copyWith(
          partyOrders: originalOrder.partyOrders
              ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
              .toList());
      newFoodOrder.value = originalOrder.copyWith(
          partyOrders: originalOrder.partyOrders
              ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
              .toList());
      return false;
    });
    return result;

    // if (currentPartyIndex.value == -2) {
    //   ///Cập nhật món ăn trong đơn với trạng thái là Alles
    //   excute(() async {
    //     final orderItems = [...(currentPartyOrder.value!.orderItems ?? <OrderItem>[])];
    //     orderItems.removeWhere((element) => element.partyOrderStaus == ORDER_STATUS.DONE);
    //     final partys = originalOrder.partyOrders
    //             ?.map((e) => e.copyWith(orderItems: e.orderItems?.map((e) => e.copyWith()).toList()))
    //             .toList() ??
    //         <PartyOrder>[];
    //     for (final item in orderItems) {
    //       final index = partys[item.partyIndex].orderItems?.indexWhere((element) =>
    //               (element.foodId == item.foodId ||
    //                   (element.food != null && item.food != null && element.food?.foodId == item.food?.foodId)) &&
    //               element.sortOder == item.sortOder) ??
    //           -1;
    //       if (index != -1) {
    //         partys[item.partyIndex].orderItems![index] = item;
    //       } else {
    //         partys[item.partyIndex].orderItems?.add(item);
    //       }
    //     }
    //     partys.removeWhere((element) => element.orderStatus == ORDER_STATUS.DONE);
    //     final resultPartys = await Future.wait(partys.map((party) async {
    //       final partyIndex =
    //           originalOrder.partyOrders?.indexWhere((element) => element.partyOrderId == party.partyOrderId) ?? -1;
    //       if (partyIndex != -1) {
    //         final result = await orderRepository.updateListOrderInParty(
    //             party,
    //             foodOrder.value!.partyOrders![partyIndex].orderItems ?? <OrderItem>[],
    //             party.orderItems ?? <OrderItem>[]);
    //         if (result.isNotEmpty) {
    //           return party.copyWith(orderItems: result);
    //         }
    //       }
    //       return party;
    //     }));
    //     for (final party in resultPartys) {
    //       final partyIndex =
    //           originalOrder.partyOrders?.indexWhere((element) => element.partyOrderId == party.partyOrderId) ?? -1;
    //       if (partyIndex != -1) {
    //         originalOrder.partyOrders?[partyIndex] = party;
    //       }
    //     }
    //     renewOrder();
    //     _createAllesPartyOrder();
    //   });
    // }
    // // else if (newParty != null && currentPartyOrder.value?.partyNumber == newParty?.partyNumber) {
    // //   ///Cập nhật món ăn ở party mới tạo và chưa tạo trên server
    // //   excute(() async {
    // //     final newParty =
    // //         await orderRepository.uploadNewPartyOrder(foodOrder.value!.orderId ?? '', currentPartyOrder.value!);
    // //     if (newParty != null) {
    // //       originalOrder.partyOrders?.add(newParty);
    // //       this.newParty = null;
    // //       renewOrder();
    // //       currentPartyOrder.value = originalOrder.partyOrders?.last;
    // //     }
    // //   });
    // // }
    // else {
    //   ///Cập nhật món ăn ở một party đang có trong giỏ hàng
    //   excute(() async {
    //     final result = await orderRepository.updateListOrderInParty(
    //         currentPartyOrder.value!,
    //         foodOrder.value!.partyOrders![currentPartyIndex.value].orderItems ?? <OrderItem>[],
    //         currentPartyOrder.value?.orderItems ?? <OrderItem>[]);
    //     if (result.isNotEmpty) {
    //       final newPartyOrder = currentPartyOrder.value!.copyWith(orderItems: result);
    //       originalOrder.partyOrders![currentPartyIndex.value] = newPartyOrder;
    //       renewOrder();
    //       currentPartyOrder.value = newPartyOrder;
    //     }
    //   });
    // }
  }

  bool isEmptyAllPartyOrder(List<PartyOrder?> partyOrders) {
    for (final party in partyOrders) {
      if ((party?.orderItems?.isNotEmpty ?? false) == true) {
        return false;
      }
    }

    return true;
  }
}
