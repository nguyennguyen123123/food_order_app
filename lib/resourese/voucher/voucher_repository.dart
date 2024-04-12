import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/voucher/ivoucher_repository.dart';

class VoucherRepository extends IVoucherRepository {
  final BaseService baseService;

  VoucherRepository({required this.baseService});

  @override
  Future<Map<String, dynamic>?> addVoucher(Voucher voucher) async {
    try {
      final response = await baseService.client.from(TABLE_NAME.VOUCHER).insert(voucher.toJson()).select();

      return response.first;
    } catch (error) {
      handleError(error);

      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> deleteVoucher(String voucherId) async {
    try {
      final data = await baseService.client.from(TABLE_NAME.VOUCHER).delete().match({'voucher_id': voucherId}).select();

      return data.first;
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<Voucher?> editVoucher(String voucherId, Voucher voucher) async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.VOUCHER)
          .update(voucher.toJson())
          .eq('voucher_id', voucherId)
          .select()
          .withConverter((data) => data.map((e) => Voucher.fromJson(e)).toList());

      return response.first;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<List<Voucher>?> getVoucher() async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.VOUCHER)
          .select()
          .withConverter((data) => data.map((e) => Voucher.fromJson(e)).toList());

      return response.toList();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
