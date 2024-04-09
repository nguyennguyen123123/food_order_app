import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class OrderRepository extends IOrderRepository {
  final BaseService baseService;
  final AccountService accountService;

  OrderRepository({required this.baseService, required this.accountService});

  @override
  Future<FoodOrder?> onPlaceOrder(List<OrderItem> orderItems, {required String tableNumber}) async {
    try {
      if (orderItems.isEmpty) return null;
      final orderId = getUuid();
      var total = 0;
      for (final item in orderItems) {
        total = (item.quantity ?? 1) * (item.food?.price ?? 0);
      }
      final foodOrder = FoodOrder(
        orderId: orderId,
        userOrder: accountService.myAccount,
        userOrderId: accountService.myAccount?.userId,
        tableNumber: tableNumber,
        total: total.toDouble(),
      );

      foodOrder.orderItems = await Future.wait(orderItems.map(_uploadOrderItem));
      final order = await baseService.client
          .from(TABLE_NAME.FOOD_ORDER)
          .insert(foodOrder.toJson())
          .select("*, user_order_id(*)")
          .withConverter((data) => data.map((e) => FoodOrder.fromJson(e)).toList());
      await Future.wait((foodOrder.orderItems ?? []).map((e) async {
        await baseService.client
            .from(TABLE_NAME.FOOD_ORDER_ITEM)
            .insert({"food_order_id": orderId, "order_item_id": e.orderItemId ?? ''});
      }).toList());
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

// food_id (*, typeId (*))
  @override
  Future<List<FoodOrder>> getListFoodOrders({int page = 0, int limit = LIMIT}) async {
    try {
      final orders = await baseService.client
          .from(TABLE_NAME.FOOD_ORDER)
          .select(
              "*, user_order_id(*), food_order_item!inner(*, order_item!inner (*, food_id:food!inner(*, typeId(*)))))")
          .withConverter((data) => data.map((e) => FoodOrder.fromJson(e)).toList());
      print(orders);
    } catch (e) {
      handleError(e);
    }
    return [];
  }
}
