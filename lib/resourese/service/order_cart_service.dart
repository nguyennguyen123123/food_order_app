import 'package:food_delivery_app/models/order_item.dart';
import 'package:get/get.dart';

class OrderCartService extends GetxService {
  final items = Rx<List<OrderItem>>([]);

  void onAddOrderItem(OrderItem orderItem) {
    final index = items.value
        .indexWhere((element) => element.foodId == orderItem.foodId || element.food?.foodId == orderItem.food?.foodId);
    if (index == -1) {
      items.update((val) => val?.add(orderItem));
    } else {
      items.update((val) => val?[index] = orderItem);
    }
  }
}
