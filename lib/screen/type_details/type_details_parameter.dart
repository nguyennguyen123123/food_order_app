import 'package:food_delivery_app/models/food_model.dart';

class TypeDetailsParamter {
  // final int gangIndex;
  final void Function(FoodModel food) onAddFoodToCart;
  final void Function(int quantity, FoodModel food) updateQuantityFoodItem;
  final int Function(FoodModel food) getQuantityFoodInCart;

  TypeDetailsParamter({
    // required this.gangIndex,
    required this.onAddFoodToCart,
    required this.updateQuantityFoodItem,
    required this.getQuantityFoodInCart,
  });
}
