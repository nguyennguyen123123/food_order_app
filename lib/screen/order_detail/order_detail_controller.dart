import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/screen/order_detail/order_detail_parameter.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  final OrderDetailParameter parameter;
  final IOrderRepository orderRepository;
  late Rx<FoodOrder> foodOrder;

  OrderDetailController({
    required this.parameter,
    required this.orderRepository,
  });

  @override
  void onInit() {
    super.onInit();
    foodOrder = Rx(parameter.foodOrder);
  }

  void updateQuantityList(int partyIndex, int itemIndex, int quantity) {
    foodOrder.update((val) {
      val?.partyOrders?[partyIndex].orderItems?[itemIndex].quantity = quantity;
    });
  }

  void onRemoveItem(int partyIndex, int itemIndex) {
    foodOrder.update((val) {
      val?.partyOrders?[partyIndex].orderItems?.removeAt(itemIndex);
    });
  }

  void addFoodToPartyOrder(int partyIndex, OrderItem orderItem) {
    foodOrder.update((val) {
      final orderIndex = val?.partyOrders?[partyIndex].orderItems
              ?.indexWhere((element) => element.food?.foodId == orderItem.food?.foodId) ??
          -1;
      if (orderIndex == -1) {
        val?.partyOrders?[partyIndex].orderItems?.add(orderItem);
      } else {
        final item = val?.partyOrders?[partyIndex].orderItems?[orderIndex];
        val?.partyOrders?[partyIndex].orderItems?[orderIndex].quantity = (item?.quantity ?? 1) + orderItem.quantity;
      }
      ;
    });
  }

  void onDeleteOrder() async {
    excute(() => orderRepository.onDeleteOrder(foodOrder.value));
    Get.back();
  }
}
