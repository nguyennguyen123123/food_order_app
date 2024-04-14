import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class IOrderRepository extends IBaseRepository {
  Future<FoodOrder?> onPlaceOrder(List<OrderItem> orderItems, List<PartyOrder> partyOrders,
      {required String tableNumber, Voucher? voucher});
  Future<List<FoodOrder>> getListFoodOrders({int page = 0, int limit = LIMIT});
}
