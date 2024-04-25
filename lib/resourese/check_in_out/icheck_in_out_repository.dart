import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/check_in_out.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class ICheckInOutRepository extends IBaseRepository {
  Future<Account?> checkInUser();
  Future<Account?> checkOutUser();
  Future<List<CheckInOut>> getListCheckInOut(bool role, {int page = 0, int limit = LIMIT});
}
