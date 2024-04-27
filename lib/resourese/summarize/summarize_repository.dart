import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/summarize_order.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/summarize/isummarize_repository.dart';

class SummarizeRepository extends ISummarizeRepository {
  final BaseService baseService;

  SummarizeRepository({required this.baseService});

  @override
  Future<void> increaseTodayRecord(double orderPrice) async {
    try {
      final today = DateTime.now();
      final records = await baseService.client
          .from(TABLE_NAME.SUMMARIZE_ORDER)
          .select('*')
          .eq('day', today.day)
          .eq('month', today.month)
          .eq('year', today.year)
          .withConverter((data) => data.map((e) => SummarizeOrder.fromMap(e)).toList());
      if (records.isNotEmpty) {
        final record = records.first;
        final totalOrder = (record.totalOrder ?? 0) + 1;
        final totalOrderPrice = (record.totalOrderPrice ?? 0) + orderPrice;
        await baseService.client.from(TABLE_NAME.SUMMARIZE_ORDER).update({
          'total_order': totalOrder,
          'total_order_price': totalOrderPrice,
        }).eq('id', record.id ?? 0);
      } else {
        final summarizeOrder = SummarizeOrder(
            day: today.day, month: today.month, year: today.year, totalOrder: 1, totalOrderPrice: orderPrice);
        await baseService.client.from(TABLE_NAME.SUMMARIZE_ORDER).insert(summarizeOrder.toMap());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<SummarizeOrder> getTodaySummarize() async {
    try {
      final today = DateTime.now();
      final records = await baseService.client
          .from(TABLE_NAME.SUMMARIZE_ORDER)
          .select('*')
          .eq('day', today.day)
          .eq('month', today.month)
          .eq('year', today.year)
          .maybeSingle()
          .withConverter((data) => data != null ? SummarizeOrder.fromMap(data) : null);
      if (records != null) {
        return records;
      } else {
        return SummarizeOrder(
          day: today.day,
          month: today.month,
          year: today.year,
          totalOrder: 0,
          totalOrderPrice: 0,
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
