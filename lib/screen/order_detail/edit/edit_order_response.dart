import 'package:food_delivery_app/models/food_order.dart';

enum EditType { CHANGE_WHOLE_ORDER_TABLE, UPDATE, CHANGE_FOOD_TABLE, CHANGE_PARTY_TABLE }

class EditOrderResponse {
  final FoodOrder foodOrder;
  final EditType type;

  EditOrderResponse({required this.foodOrder, required this.type});
}
