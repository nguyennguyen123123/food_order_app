import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

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
    List<OrderItem> orderItems,
    List<PartyOrder> partyOrders, {
    required String tableNumber,
    Voucher? voucher,
    int bondNumber = 1,
  }) async {
    try {
      if (orderItems.isEmpty && partyOrders.isEmpty) {
        throw Exception();
      }
      partyOrders.removeWhere((element) => (element.orderItems?.isEmpty ?? true) == true);
      final orders = <PartyOrder>[
        PartyOrder(orderItems: orderItems, voucher: voucher),
        ...partyOrders,
      ];

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
      );

      // foodOrder.orderItems = await Future.wait(orderItems.map(_uploadOrderItem));

      final order = await baseService.client
          .from(TABLE_NAME.FOOD_ORDER)
          .insert(foodOrder.toJson())
          .select("*, user_order_id(*)")
          .withConverter((data) => data.map((e) => FoodOrder.fromJson(e)).toList());

      // await _uploadPartyOrderItem(orders, orderId);
      Future.wait([
        _uploadPartyOrderItem(orders, orderId),
        profileRepository.updateNumberOfOrder(accountService.myAccount?.userId ?? '', bondNumber + 1),
        tableRepository.updateTableWithOrder(tableNumber, orderId: orderId),
      ]);
      // await profileRepository.updateNumberOfOrder(accountService.myAccount?.userId ?? '', bondNumber + 1);
      accountService.account.value = accountService.myAccount?.copyWith(numberOfOrder: bondNumber + 1);
      return order.first;
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
        total: party.totalPrice,
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
        tableRepository.updateTableWithOrder(model.tableNumber.toString(), orderId: foodOrder.orderId),
      ]);
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
