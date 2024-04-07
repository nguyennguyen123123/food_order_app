import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class IProfileRepository extends IBaseRepository {
  Future<void> signOut();
  Future<Account?> getProfile();
}
