import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/screen/history_order/history_order_controller.dart';
import 'package:food_delivery_app/screen/order_detail/view/order_detail_parameter.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  final OrderDetailParameter parameter;
  final IOrderRepository orderRepository;
  late Rx<FoodOrder> foodOrder;
  final AccountService accountService;

  OrderDetailController({
    required this.parameter,
    required this.accountService,
    required this.orderRepository,
  });

  @override
  void onInit() {
    super.onInit();
    foodOrder = Rx(parameter.foodOrder);
  }

  void updateQuantityList(int partyIndex, OrderItem item, int quantity) {
    foodOrder.update((val) {
      final index = val?.partyOrders?[partyIndex].orderItems
              ?.indexWhere((element) => element.food?.foodId == item.food?.foodId) ??
          -1;
      if (index != -1) {
        val?.partyOrders?[partyIndex].orderItems?[index].quantity = quantity;
      }
    });
  }

  void onRemoveItem(int partyIndex, OrderItem item) {
    foodOrder.update((val) {
      final index = val?.partyOrders?[partyIndex].orderItems
              ?.indexWhere((element) => element.food?.foodId == item.food?.foodId) ??
          -1;
      if (index != -1) {
        val?.partyOrders?[partyIndex].orderItems?.removeAt(index);
      }
    });
  }

  void addFoodToPartyOrder(int partyIndex, List<OrderItem> orderItems) {
    final order = foodOrder.value;
    for (final item in orderItems) {
      final orderIndex = order.partyOrders?[partyIndex].orderItems
              ?.indexWhere((element) => element.food?.foodId == item.food?.foodId) ??
          -1;
      if (orderIndex == -1) {
        order.partyOrders?[partyIndex].orderItems?.add(item);
      } else {
        final curItem = order.partyOrders?[partyIndex].orderItems?[orderIndex];
        order.partyOrders?[partyIndex].orderItems?[orderIndex].quantity = (curItem?.quantity ?? 1) + item.quantity;
      }
    }
    foodOrder.value = order;
    foodOrder.refresh();
  }

  void onDeleteOrder() async {
    await excute(() => orderRepository.onDeleteOrder(foodOrder.value));
    if (Get.isRegistered<HistoryOrderController>()) {
      Get.find<HistoryOrderController>().onRemoveFoodOrder(foodOrder.value);
    }
    Get.back();
  }
}
