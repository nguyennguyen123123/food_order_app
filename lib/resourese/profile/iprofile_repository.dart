import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class IProfileRepository extends IBaseRepository {
  Future<void> signOut();
  Future<Account?> getProfile();
  Future<Account?> updateProfile(String name, String gender);
  Future<void> updateNumberOfOrder(int number);
}
