import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/table_models.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class IOrderRepository extends IBaseRepository {
  Future<FoodOrder?> onPlaceOrder(List<OrderItem> orderItems, List<PartyOrder> partyOrders,
      {required String tableNumber, Voucher? voucher, int bondNumber = 1});
  Future<List<FoodOrder>> getListFoodOrders(
      {int page = 0, int limit = LIMIT, String? orderStatus, String? userOrderId});
  Future<void> onDeleteOrder(FoodOrder foodOrder);
  Future<bool> onChangeTableOfOrder(FoodOrder foodOrder, TableModels model);
  Future<bool> onChangeOrderItemToOtherTable(
      String currentOrderId, PartyOrder partyOrder, List<String> selectedOrderItemsId, TableModels tableModels);
  Future<FoodOrder?> getOrderDetail(String orderId);
  Future<bool> completeOrder(String orderId, String tableNumber);
  Future<bool> completePartyOrder(String partyOrderId);
  Future<List<OrderItem>> updateListOrderInParty(
      PartyOrder partyOrder, List<OrderItem> orignalOrderItem, List<OrderItem> orderItem);
  Future<PartyOrder?> uploadNewPartyOrder(String orderId, PartyOrder partyOrder);
}
