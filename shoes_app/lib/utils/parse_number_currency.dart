import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    double value = double.parse(newValue.text);
    final money = NumberFormat("###,###,###", "id");

    String newText = money.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String parseNumberCurrencyWithRp(num number) {
    final String result;
    result = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0)
        .format(number)
        .replaceAll(',', '.');
    return result;
  }

  String parseNumberCurrencyWithOutRp(num number) {
    final String result;
    result = NumberFormat.currency(symbol: '', decimalDigits: 0)
        .format(number)
        .replaceAll(',', '.');
    return result;
  }

  String replaceFormatCurrency(String textController) {
    final String resultReplaceCurrency;
    resultReplaceCurrency = textController.replaceAll('.', '');
    return resultReplaceCurrency;
  }
}
