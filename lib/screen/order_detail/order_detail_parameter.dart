import 'package:food_delivery_app/models/food_order.dart';

class OrderDetailParameter {
  final FoodOrder foodOrder;
  final bool canEdit;

  OrderDetailParameter({required this.foodOrder, this.canEdit = false});
}
