import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
      // final f = NumberFormat('#,###');
      final f = NumberFormat('#,###', "en_US");
      final number = double.tryParse(newValue.text.replaceAll(",", "")) ?? 0.0;
      final numberTxtSplit = number.toString().split('.');
      final firstTxt = int.parse(numberTxtSplit.first);
      final second = numberTxtSplit.length > 1 ? int.parse(numberTxtSplit.last) : 0;
      var newString = f.format(firstTxt);
      if (second > 99) {
        newString += '.99';
      } else if (second <= 99 && second >= 0) {
        newString += '.$second';
      }
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

class PercentageTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;

      final number = int.tryParse(newValue.text) ?? 0;
      final newText = number > 100 ? '99' : number.toString();
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: newText.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
