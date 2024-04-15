import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/check_in_out.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class ICheckInOutRepository extends IBaseRepository {
  Future<Map<String, dynamic>?> checkInUser();
  Future<Map<String, dynamic>?> checkOutUser();
  Future<List<CheckInOut>> getListCheckInOut(bool role, {int page = 0, int limit = LIMIT});
}
