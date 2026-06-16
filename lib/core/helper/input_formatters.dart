import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    const int a = 3;
    if (newTextLength >= a) {
      newText
          .write('${newValue.text.substring(0, usedSubstringIndex = a - 1)}/');
      if (newValue.selection.end >= a - 1) selectionIndex++;
    }

    const int b = 5;
    if (newTextLength >= b) {
      newText
          .write('${newValue.text.substring(2, usedSubstringIndex = b - 1)}/');
      if (newValue.selection.end >= b - 1) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class CardInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    const int a = 5;
    if (newTextLength >= a) {
      newText
          .write('${newValue.text.substring(0, usedSubstringIndex = a - 1)}-');
      if (newValue.selection.end >= a - 1) selectionIndex++;
    }

    const int b = 9;
    if (newTextLength >= b) {
      newText
          .write('${newValue.text.substring(4, usedSubstringIndex = b - 1)}-');
      if (newValue.selection.end >= b - 1) selectionIndex++;
    }

    const int c = 13;
    if (newTextLength >= c) {
      newText
          .write('${newValue.text.substring(8, usedSubstringIndex = c - 1)}-');
      if (newValue.selection.end >= c - 1) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    const int a = 5;
    if (newTextLength >= a) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = a - 1)}-');
      if (newValue.selection.end >= a - 1) selectionIndex++;
    }

    const int b = 8;
    if (newTextLength >= b) {
      newText.write('${newValue.text.substring(4, usedSubstringIndex = b - 1)}-');
      if (newValue.selection.end >= b - 1) selectionIndex++;
    }

    const int c = 13;
    if (newTextLength >= c) {
      newText.write('${newValue.text.substring(7, usedSubstringIndex = c - 1)}-');
      if (newValue.selection.end >= c - 1) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
