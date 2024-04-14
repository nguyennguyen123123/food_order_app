import 'package:food_delivery_app/models/voucher.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getCurrency(double? price, {bool removeCurrencyFormat = false}) {
    if (removeCurrencyFormat) {
      return NumberFormat('#,###').format(price ?? 0);
    }
    return NumberFormat.simpleCurrency(name: '€').format(price ?? 0);
  }

  static double calculateVoucherPrice(Voucher? voucher, double price) {
    if (voucher != null) {
      final salePrice = voucher.discountValue;
      if (voucher.discountType == DiscountType.amount) {
        return (salePrice ?? 0).toDouble();
      } else {
        return price * (((salePrice ?? 100) / 100));
      }
    }

    return price;
  }
}
