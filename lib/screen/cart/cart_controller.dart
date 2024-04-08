import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final OrderCartService cartService;

  CartController({required this.cartService});
}
