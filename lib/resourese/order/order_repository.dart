import 'dart:math';

import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:get/get.dart';

abstract class _ORDER_COLUMN_KEY {
  static const PARTY_ORDER_ID = 'party_order_id';
  static const ORDER_ITEM_ID = 'order_item_id';
  static const ORDER_ID = 'order_id';
  static const ORDER_STATUS = 'order_status';
  static const USER_ORDER_ID = 'user_order_id';
}

class OrderRepository extends IOrderRepository {
  final BaseService baseService;
  final IProfileRepository profileRepository;
  final AccountService accountService;
  final ITableRepository tableRepository;

  OrderRepository({
    required this.baseService,
    required this.accountService,
    required this.profileRepository,
    required this.tableRepository,
  });

  @override
  Future<FoodOrder?> onPlaceOrder(
    List<PartyOrder> partyOrders, {
    required String tableNumber,
    int bondNumber = 1,
  }) async {
    try {
      if (partyOrders.isEmpty) {
        throw Exception();
      }
      partyOrders.removeWhere((element) => (element.orderItems?.isEmpty ?? true) == true);

      final orderId = getUuid();
      var total = 0.0;
      for (final item in partyOrders) {
        total += item.totalPrice;
      }
      final foodOrder = FoodOrder(
        orderId: orderId,
        userOrder: accountService.myAccount,
        userOrderId: accountService.myAccount?.userId,
        tableNumber: tableNumber,
        total: total.toDouble(),
        orderStatus: ORDER_STATUS.CREATED,
        orderType: partyOrders.length > 1 ? ORDER_TYPE.PARTY : ORDER_TYPE.NORMAL,
        bondNumber: bondNumber,
        partyOrders: partyOrders,
      );

      // foodOrder.orderItems = await Future.wait(orderItems.map(_uploadOrderItem));
      /// Tạo đơn
      final order = await baseService.client
          .from(TABLE_NAME.FOOD_ORDER)
          .insert(foodOrder.toJson())
          .select("*, user_order_id(*)")
          .withConverter((data) => data.map((e) => FoodOrder.fromJson(e)).toList());

      // await _uploadPartyOrderItem(orders, orderId);
      // Tạo dữ liệu cho các party
      Future.wait([
        _uploadPartyOrderItem(partyOrders, orderId),
        profileRepository.updateNumberOfOrder(accountService.myAccount?.userId ?? '', bondNumber + 1),
        tableRepository.updateTableWithOrder(tableNumber, orderId: orderId),
      ]);
      // await profileRepository.updateNumberOfOrder(accountService.myAccount?.userId ?? '', bondNumber + 1);
      accountService.account.value = accountService.myAccount?.copyWith(numberOfOrder: bondNumber + 1);
      return foodOrder;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<OrderItem> _uploadOrderItem(OrderItem item) async {
    final id = getUuid();
    item.orderItemId = id;
    final result = await baseService.client
        .from(TABLE_NAME.ORDER_ITEM)
        .insert(item.toJson())
        .select("*, food_id (*, typeId(*) )")
        .withConverter((data) => data.map((e) => OrderItem.fromJson(e)).toList());
    return result.first;
  }

  Future<void> _uploadPartyOrderItem(List<PartyOrder> partyOrders, String orderId) async {
    await Future.wait(partyOrders.map((party) async {
      final partyId = getUuid();

      final newParty = party.copyWith(
        partyOrderId: partyId,
        orderId: orderId,
        total: party.totalPriceWithoutVoucher,
        orderStatus: ORDER_STATUS.CREATED,
      );
      newParty.voucherPrice = newParty.voucher?.discountValue;
      newParty.voucherType = newParty.voucher?.discountType?.toString();

      await baseService.client.from(TABLE_NAME.PARTY_ORDER).insert(newParty.toJson());

      final orderItems = party.orderItems ?? <OrderItem>[];
      await Future.wait(orderItems.map((item) async {
        final newItem = await _uploadOrderItem(item.copyWith(partyOderId: partyId));
        await baseService.client
            .from(TABLE_NAME.PARTY_ORDER_ITEM)
            .insert({'party_order_id': partyId, 'order_item_id': newItem.orderItemId});
      }));
      await baseService.client
          .from(TABLE_NAME.ORDER_WITH_PARTY)
          .insert({'order_id': orderId, 'party_order_id': partyId});
    }));
  }

  @override
  Future<FoodOrder?> getOrderDetail(String orderId) async {
    try {
      const queryOrder = 'order_item!inner (*, food_id:food!inner(*, typeId(*))))';
      var query = baseService.client.from(TABLE_NAME.FOOD_ORDER).select('''
        *,
        user_order_id(*),
        ${TABLE_NAME.ORDER_WITH_PARTY}!inner(party_order!inner(*, party_order_item!inner($queryOrder))),
        ${TABLE_NAME.FOOD_ORDER_ITEM}!inner(*, $queryOrder),
        ''').eq('order_id', orderId);
      final response = await query.withConverter((data) => data.map((e) => FoodOrder.fromJson(e)).toList());

      return response.first;
    } catch (e) {
      handleError(e);
    }
    return null;
  }

// food_id (*, typeId (*))
  @override
  Future<List<FoodOrder>> getListFoodOrders(
      {int page = 0, int limit = LIMIT, String? orderStatus, String? userOrderId}) async {
    try {
      const queryOrder = 'order_item!inner (*, food_id:food!inner(*, typeId(*))))';
      var query = baseService.client.from(TABLE_NAME.FOOD_ORDER).select('''
        *,
        user_order_id(*),
        ${TABLE_NAME.ORDER_WITH_PARTY}!inner(party_order!inner(*, party_order_item!inner($queryOrder))),
        ${TABLE_NAME.FOOD_ORDER_ITEM}!inner(*, $queryOrder),
        ''');
//         ${TABLE_NAME.ORDER_WITH_PARTY}!inner(party_order!inner(*, party_order_item!inner($queryOrder))),
      if (orderStatus != null) {
        query = query.eq('order_status', orderStatus);
      }
      if (userOrderId != null) {
        query = query.eq('user_order_id', userOrderId);
      }
      final response = await query
          .limit(limit)
          .range(page * limit, (page + 1) * limit)
          .withConverter((data) => data.map((e) => FoodOrder.fromJson(e)).toList());

      return response.toList();
    } catch (e) {
      handleError(e);
    }
    return [];
  }

  @override
  Future<void> onDeleteOrder(FoodOrder foodOrder) async {
    try {
      await baseService.client.from(TABLE_NAME.FOOD_ORDER).delete().eq('order_id', foodOrder.orderId ?? '');
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> onChangeTableOfOrder(FoodOrder foodOrder, TableModels model) async {
    try {
      await Future.wait([
        baseService.client
            .from(TABLE_NAME.FOOD_ORDER)
            .update({'table_number': model.tableNumber}).eq('order_id', foodOrder.orderId ?? ''),
        tableRepository.updateTableWithOrder(foodOrder.tableNumber ?? ''),
        tableRepository.updateTableWithOrder(model.tableNumber ?? '', orderId: foodOrder.orderId),
      ]);
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<bool> onChangeOrderItemToOtherTable(
      String currentOrderId, PartyOrder partyOrder, List<String> selectedOrderItemsId, TableModels tableModels) async {
    try {
      final isSelectAll = partyOrder.orderItems?.length == selectedOrderItemsId.length;
      final selectOrderItems =
          partyOrder.orderItems!.where((element) => selectedOrderItemsId.contains(element.orderItemId)).toList();
      final table = await tableRepository.getTableByNumber(tableModels.tableNumber ?? '');
      if (table != null) {
        if (tableModels.foodOrderId == null && tableModels.foodOrder == null) {
          /// Trường hợp bàn đó chưa có đơn nào
          final orderId = getUuid();
          final newOrder = FoodOrder(
            tableNumber: table.tableNumber,
            orderId: orderId,
            userOrder: accountService.myAccount,
            userOrderId: accountService.myAccount?.userId,
            orderStatus: ORDER_STATUS.CREATED,
            orderType: ORDER_TYPE.NORMAL,
            bondNumber: 1,
          );
          await baseService.client
              .from(TABLE_NAME.FOOD_ORDER)
              .insert(newOrder.toJson())
              .select("*, user_order_id(*)")
              .withConverter((data) => data.map((e) => FoodOrder.fromJson(e)).toList());
          if (isSelectAll) {
            /// Muốn chuyển tất cả món trong party
            await baseService.client
                .from(TABLE_NAME.ORDER_WITH_PARTY)
                .delete()
                .eq('order_id', currentOrderId)
                .eq('party_order_id', partyOrder.partyOrderId ?? '');
            await baseService.client
                .from(TABLE_NAME.ORDER_WITH_PARTY)
                .insert({'order_id': orderId, 'party_order_id': partyOrder.partyOrderId ?? ''});
          } else {
            ///Chỉ chuyển một số món trong party
            await _uploadPartyWithOrderItem(
                partyOrder.partyOrderId ?? '', PartyOrder(orderItems: selectOrderItems), orderId);
          }
          await tableRepository.updateTableWithOrder(tableModels.tableNumber ?? '', orderId: orderId);
        } else {
          /// Trường hợp bàn đó đã có đơn
          final orderId = tableModels.foodOrder?.orderId ?? '';
          if (isSelectAll) {
            /// Muốn chuyển tất cả món trong party

            await baseService.client
                .from(TABLE_NAME.ORDER_WITH_PARTY)
                .delete()
                .eq('order_id', currentOrderId)
                .eq('party_order_id', partyOrder.partyOrderId ?? '');
            await baseService.client
                .from(TABLE_NAME.ORDER_WITH_PARTY)
                .insert({'order_id': orderId, 'party_order_id': partyOrder.partyOrderId ?? ''});
          } else {
            ///Chỉ chuyển một số món trong party
            int? newPartyNumber = null;
            final isContainNullNumber =
                tableModels.foodOrder?.partyOrders?.firstWhereOrNull((element) => element.partyNumber == null) != null;
            if (isContainNullNumber) {
              for (final party in tableModels.foodOrder!.partyOrders!) {
                if (party.partyNumber != null) {
                  if (newPartyNumber == null) {
                    newPartyNumber = party.partyNumber;
                  } else {
                    newPartyNumber = max(newPartyNumber, party.partyNumber ?? 0);
                  }
                }
              }
              newPartyNumber = (newPartyNumber ?? 0) + 1;
            }
            await _uploadPartyWithOrderItem(partyOrder.partyOrderId ?? '',
                PartyOrder(orderItems: selectOrderItems, partyNumber: newPartyNumber), orderId);
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<PartyOrder?> _uploadPartyWithOrderItem(String oldPartyOrderId, PartyOrder party, String orderId) async {
    try {
      final partyId = getUuid();

      final newParty = party.copyWith(
        partyOrderId: partyId,
        orderId: orderId,
        total: party.totalPriceWithoutVoucher,
        orderStatus: ORDER_STATUS.CREATED,
      );

      await baseService.client.from(TABLE_NAME.PARTY_ORDER).insert(newParty.toJson());
      await baseService.client
          .from(TABLE_NAME.ORDER_WITH_PARTY)
          .insert({'order_id': orderId, 'party_order_id': partyId});
      final orderItems = party.orderItems ?? <OrderItem>[];
      await Future.wait(orderItems.map((item) async {
        await baseService.client
            .from(TABLE_NAME.PARTY_ORDER_ITEM)
            .delete()
            .eq('party_order_id', oldPartyOrderId)
            .eq('order_item_id', item.orderItemId ?? '');
        await baseService.client
            .from(TABLE_NAME.ORDER_ITEM)
            .update({'party_order_id': partyId, 'sort_order': null}).eq('order_item_id', item.orderItemId ?? '');
        await baseService.client
            .from(TABLE_NAME.PARTY_ORDER_ITEM)
            .insert({'party_order_id': partyId, 'order_item_id': item.orderItemId});
      }));
      return party;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> completeOrder(String orderId, String tableNumber) async {
    try {
      await Future.wait([
        baseService.client
            .from(TABLE_NAME.FOOD_ORDER)
            .update({_ORDER_COLUMN_KEY.ORDER_STATUS: ORDER_STATUS.DONE}).eq(_ORDER_COLUMN_KEY.ORDER_ID, orderId),
        tableRepository.updateTableWithOrder(tableNumber)
      ]);
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  @override
  Future<bool> completeListPartyOrder(List<String> partyIds) async {
    try {
      await Future.wait(partyIds.map((id) async {
        if (id.isNotEmpty) {
          await baseService.client
              .from(TABLE_NAME.PARTY_ORDER)
              .update({_ORDER_COLUMN_KEY.ORDER_STATUS: ORDER_STATUS.DONE}).eq(_ORDER_COLUMN_KEY.PARTY_ORDER_ID, id);
        }
      }));
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  @override
  Future<bool> completePartyOrder(String partyOrderId) async {
    try {
      await baseService.client.from(TABLE_NAME.PARTY_ORDER).update(
          {_ORDER_COLUMN_KEY.ORDER_STATUS: ORDER_STATUS.DONE}).eq(_ORDER_COLUMN_KEY.PARTY_ORDER_ID, partyOrderId);
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  @override
  Future<List<OrderItem>> updateListOrderInParty(
      PartyOrder partyOrder, List<OrderItem> orignalOrderItem, List<OrderItem> orderItem) async {
    try {
      //Xoá những item này
      final deleteItem = <OrderItem>[];
      final newItem = orderItem.where((element) => element.orderItemId == null).toList();
      for (final item in orignalOrderItem) {
        final index = orderItem.indexWhere((element) =>
            element.food?.foodId == item.food?.foodId &&
            item.sortOder == element.sortOder &&
            item.partyIndex == element.partyIndex);
        if (index == -1) {
          deleteItem.add(item);
        }
      }
      final oldOrderItem = orderItem.where((element) => element.orderItemId != null).toList();

      if (deleteItem.isNotEmpty) {
        await deleteListOrderItem(deleteItem);
      }
      await baseService.client.from(TABLE_NAME.PARTY_ORDER).update({
        'voucher_price': partyOrder.voucherPrice,
        'voucher_type': partyOrder.voucherType,
      }).eq(_ORDER_COLUMN_KEY.PARTY_ORDER_ID, partyOrder.partyOrderId ?? '');
      await Future.wait(oldOrderItem.map((item) async {
        return baseService.client
            .from(TABLE_NAME.ORDER_ITEM)
            .update({'sort_order': item.sortOder, 'quantity': item.quantity})
            .eq(_ORDER_COLUMN_KEY.ORDER_ITEM_ID, item.orderItemId ?? '')
            .select("*, food_id (*, typeId(*) )")
            .withConverter((data) => data.map((e) => OrderItem.fromJson(e)).toList());
      }));
      final result = await Future.wait(newItem.map((item) async {
        final newItem = await _uploadOrderItem(item.copyWith(partyOderId: partyOrder.partyOrderId));
        await baseService.client
            .from(TABLE_NAME.PARTY_ORDER_ITEM)
            .insert({'party_order_id': partyOrder.partyOrderId, 'order_item_id': newItem.orderItemId});
        return newItem;
      }));
      return [...oldOrderItem, ...result];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteListOrderItem(List<OrderItem> orderItems) async {
    await Future.wait(orderItems.map((e) => baseService.client
        .from(TABLE_NAME.ORDER_ITEM)
        .delete()
        .eq(_ORDER_COLUMN_KEY.ORDER_ITEM_ID, e.orderItemId ?? '')));
  }

  @override
  Future<PartyOrder?> uploadNewPartyOrder(String orderId, PartyOrder partyOrder) async {
    try {
      final partyId = getUuid();

      final newParty = partyOrder.copyWith(
        partyOrderId: partyId,
        orderId: orderId,
        total: partyOrder.totalPriceWithoutVoucher,
        orderStatus: ORDER_STATUS.CREATED,
        voucherPrice: partyOrder.voucher?.discountValue,
        voucherType: partyOrder.voucher?.discountType.toString(),
      );

      await baseService.client.from(TABLE_NAME.PARTY_ORDER).insert(newParty.toJson());

      final orderItems = partyOrder.orderItems ?? <OrderItem>[];
      newParty.orderItems = await Future.wait(orderItems.map((item) async {
        final newItem = await _uploadOrderItem(item.copyWith(partyOderId: partyId));
        await baseService.client
            .from(TABLE_NAME.PARTY_ORDER_ITEM)
            .insert({'party_order_id': partyId, 'order_item_id': newItem.orderItemId});
        return newItem;
      }));
      await baseService.client
          .from(TABLE_NAME.ORDER_WITH_PARTY)
          .insert({'order_id': orderId, 'party_order_id': partyId});
      return newParty;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<bool> onDeletePartyOrder(String partyOrderId) async {
    try {
      await Future.wait([
        baseService.client
            .from(TABLE_NAME.ORDER_WITH_PARTY)
            .delete()
            .eq(_ORDER_COLUMN_KEY.PARTY_ORDER_ID, partyOrderId),
        baseService.client.from(TABLE_NAME.PARTY_ORDER).delete().eq(_ORDER_COLUMN_KEY.PARTY_ORDER_ID, partyOrderId)
      ]);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
