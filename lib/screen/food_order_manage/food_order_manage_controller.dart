import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:get/get.dart';

class FoodOrderManageController extends GetxController {
  final IOrderRepository orderRepository;

  FoodOrderManageController({required this.orderRepository});
}
