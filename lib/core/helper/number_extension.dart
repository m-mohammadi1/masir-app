import 'package:intl/intl.dart';

extension NumberExtensionStringInt on int? {
  String get toPersianNumber {
    if (this == null) return "";
    String number = toString();

    _numbers.forEach((key, value) => number = number.replaceAll(key, value));

    return number;
  }

  String get toEnglishNumber {
    if (this == null) return "";
    String number = toString();

    _numbers.forEach((key, value) => number = number.replaceAll(value, key));

    return number;
  }
}

extension NumberFormatter on num {
  String get toPrice {
    return NumberFormat('#,##0.##').format(this);
  }
}

extension NumberExtensionStringDouble on double? {
  String get toPersianNumber {
    if (this == null) return '';
    String number = toString();

    _numbers.forEach((key, value) => number = number.replaceAll(key, value));

    return number;
  }

  String get toEnglishNumber {
    if (this == null) return '';
    String number = toString();

    _numbers.forEach((key, value) => number = number.replaceAll(value, key));

    return number;
  }
}

extension NumberExtensionStringNum on num? {
  String get toPersianNumber {
    if (this == null) return '';
    String number = toString();

    _numbers.forEach((key, value) => number = number.replaceAll(key, value));

    return number;
  }

  String get toEnglishNumber {
    if (this == null) return '';
    String number = toString();

    _numbers.forEach((key, value) => number = number.replaceAll(value, key));

    return number;
  }
}

extension NumberExtensionString on String? {
  String get toPersianNumber {
    String number = this ?? '';

    _numbers.forEach((key, value) => number = number.replaceAll(key, value));

    return number;
  }

  String get toEnglishNumber {
    String number = this ?? '';

    _numbers.forEach((key, value) => number = number.replaceAll(value, key));

    return number;
  }

  String get justNumber {
    return (this ?? '').replaceAll(RegExp(r"[^0-9]"), '');
  }

  String get justIntNumber {
    final data = int.parse((this ?? '').replaceAll(RegExp(r"[^0-9]"), ''));
    return data.toEnglishNumber;
  }
}

const Map<String, String> _numbers = {
  '0': '۰',
  '1': '۱',
  '2': '۲',
  '3': '۳',
  '4': '۴',
  '5': '۵',
  '6': '۶',
  '7': '۷',
  '8': '۸',
  '9': '۹',
};
