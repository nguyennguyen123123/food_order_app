import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:get/get.dart';

class FoodOrderManageController extends GetxController {
  final IOrderRepository orderRepository;
  final AccountService accountService;

  FoodOrderManageController({
    required this.orderRepository,
    required this.accountService,
  });

  final foodOrderList = Rx<List<FoodOrder>?>(null);

  int page = 0;
  int limit = LIMIT;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  Future<void> onRefresh() async {
    final result = await getListFoodOrders();

    foodOrderList.value = result;
  }

  Future<bool> onLoadMore() async {
    final length = (foodOrderList.value ?? []).length;
    if (length < LIMIT * (page + 1)) return false;
    page += 1;

    final result = await getListFoodOrders();

    foodOrderList.update((val) => val?.addAll(result));
    if (result.length < limit) return false;
    return true;
  }

  Future<List<FoodOrder>> getListFoodOrders() => orderRepository.getListFoodOrders(
        page: page,
        limit: limit,
        orderStatus: ORDER_STATUS.CREATED,
        userOrderId: accountService.myAccount?.userId,
      );
}
