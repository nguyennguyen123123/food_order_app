import 'package:food_delivery_app/constant/translations/localization_service.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getCurrency(int? price, {bool removeCurrencyFormat = false}) {
    if (removeCurrencyFormat) {
      return NumberFormat('#,###').format(price ?? 0);
    }
    return NumberFormat.simpleCurrency(locale: LocalizationService.locale.toString()).format(price ?? 0);
  }
}
