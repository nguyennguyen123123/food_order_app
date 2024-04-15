import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class IVoucherRepository extends IBaseRepository {
  Future<Map<String, dynamic>?> addVoucher(Voucher voucher);
  Future<List<Voucher>> getVoucher({int page = 0, int limit = LIMIT});
  Future<Voucher?> editVoucher(String voucherId, Voucher voucher);
  Future<Map<String, dynamic>?> deleteVoucher(String voucherId);
}
