import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/voucher.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getCurrency(double? price, {bool removeCurrencyFormat = false}) {
    if (removeCurrencyFormat) {
      return NumberFormat.simpleCurrency(name: '').format(price ?? 0);
    }
    return NumberFormat.simpleCurrency(name: '€').format(price ?? 0);
  }

  static double calculatePartyVoucher(PartyOrder partyOrder, double price) {
    if (partyOrder.voucher != null) {
      if (partyOrder.voucher?.discountType == DiscountType.amount) {
        price -= partyOrder.voucher?.discountValue ?? 0;
      } else {
        price = price * (1 - ((partyOrder.voucher?.discountValue ?? 100) / 100));
      }
      return price;
    }

    if (partyOrder.voucherPrice != null && partyOrder.voucherType != null) {
      if (partyOrder.voucherType == DiscountType.amount.toString()) {
        price -= partyOrder.voucherPrice ?? 0;
      } else {
        price = price * (1 - ((partyOrder.voucherPrice ?? 100) / 100));
      }
      return price;
    }

    return price;
  }

  static double calculateVoucherPrice(Voucher? voucher, double price) {
    if (voucher != null) {
      if (voucher.discountType == DiscountType.amount) {
        price -= voucher.discountValue ?? 0;
      } else {
        price -= price * (1 - ((voucher.discountValue ?? 100) / 100));
      }
    }

    return price;
  }
}
