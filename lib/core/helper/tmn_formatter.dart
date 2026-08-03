import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // اگر خالی شد
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // حذف کاماهای قبلی
    final numericText = newValue.text.replaceAll(',', '');

    // فقط عدد قبول شود
    if (int.tryParse(numericText) == null) {
      return oldValue;
    }

    final formatted = _formatter.format(int.parse(numericText));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
