import 'package:food_delivery_app/models/summarize_order.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class ISummarizeRepository extends IBaseRepository {
  Future<void> increaseTodayRecord(double orderPrice);
  Future<SummarizeOrder> getTodaySummarize();
}
