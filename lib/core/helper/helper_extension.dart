import 'dart:math';

import 'package:flutter/cupertino.dart';

final Map<String, String> days = {
  "saturday": "شنبه",
  "sunday": "یک شنبه",
  "monday": "دوشنبه",
  "tuesday": "سه شنبه",
  "wednesday": "چهار شنبه",
  "thursday": "پنج شنبه",
  "friday": "جمعه",
};

extension ListHandler on List? {
  bool get isNotNull => this != null && this!.isNotEmpty;

  bool get isNull => this == null || (this ?? []).isEmpty;

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension HexColor on String {
  Color toColor() {
    final hex = replaceAll('#', '');
    return Color(int.parse(hex.length == 6 ? 'FF$hex' : hex, radix: 16));
  }
}

extension FormValidation on String? {
  bool get isValidEmail {
    if (this == null) return false;
    final emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailRegExp.hasMatch(this!);
  }

  String get toCheckStr => toString().trim().toLowerCase();

  bool get isNotNull => this != null && this!.trim().isNotEmpty;

  bool get isNull => this == null || (this ?? '').trim().isEmpty;

  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  bool get isValidPhone {
    if (this == null) return false;
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this!);
  }

  bool get isValidDate {
    if (this == null) return false;
    final dateRegExp = RegExp(
      r"^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$",
    );
    return dateRegExp.hasMatch(this!);
  }

  bool get isValidBank {
    if (this == null) return false;
    final dateRegExp = RegExp(r"^([0-9]{11})|([0-9]{2}-[0-9]{3}-[0-9]{6})$");
    return dateRegExp.hasMatch(this!.replaceAll('-', ''));
  }

  String fixNumber(bool isPersian) {
    const Map<String, String> numbers = {
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

    String number = this ?? "";

    if (isPersian) {
      numbers.forEach((key, value) => number = number.replaceAll(key, value));
    } else {
      numbers.forEach((key, value) => number = number.replaceAll(value, key));
    }

    return number;
  }

  String get fixNumberToEnglish {
    const Map<String, String> numbers = {
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

    String number = this ?? "";

    numbers.forEach((key, value) => number = number.replaceAll(value, key));

    return number;
  }

  String get fixNumberToPersian {
    const Map<String, String> numbers = {
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    String number = this ?? "";

    numbers.forEach((key, value) => number = number.replaceAll(value, key));

    return number;
  }

  String get cardNumberFormat {
    List<String> ls = [];

    int start = 0;
    for (int i = 0; i < (this ?? "").length;) {
      i += 4;
      if (i > (this ?? "").length) i = (this ?? "").length;
      ls.add((this ?? "").substring(start, i));
      start = i;
    }
    String temp = "";
    for (var value in ls.reversed) {
      temp += "$value    ";
    }
    return temp;
  }
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String get toHoursMinutes {
    if (inSeconds <= 0) {
      return "00:00";
    }
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  String get toMinutesSeconds {
    if (inSeconds <= 0) {
      return "00:00";
    }

    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String get toHoursMinutesSeconds {
    if (inSeconds <= 0) {
      return "00:00:00";
    }

    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String get formatDuration {
    if (inSeconds <= 0) return "00:00:00";
    var seconds = inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add(_toTwoDigits(days));
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add(_toTwoDigits(hours));
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add(_toTwoDigits(minutes));
    }
    tokens.add(_toTwoDigits(seconds));
    return tokens.join(':');
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

extension PriceExtensionDouble on double? {
  // String get toDollarPrice {
  //   return "\$ ${(this ?? 0).toStringAsFixed(2)}"
  //       .replaceAllMapped(_priceReg, _mathFunc)
  //       .fixNumber;
  // }
  String get toPrice =>
      "$this".replaceAllMapped(_priceReg, _mathFunc).fixNumber(false);
}

extension PriceExtensionInt on num? {
  // String get toDollarPrice {
  //   return "\$ ${(this ?? 0).toStringAsFixed(2)}"
  //       .replaceAllMapped(_priceReg, _mathFunc)
  //       .fixNumber;
  // }

  String get toPrice =>
      "$this".replaceAllMapped(_priceReg, _mathFunc).fixNumber(false);
}

final RegExp _priceReg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String Function(Match) _mathFunc = (Match match) => '${match[1]},';

String getFileSizeString({required int bytes, int decimals = 0}) {
  if (bytes <= 0) return "0 Bytes";
  const suffixes = [" Bytes", " KB", " MB", " GB", " TB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}

String fileUrl(String url) {
  String str = url.split('/').last.length > 20
      ? url
            .split('/')
            .last
            .substring(
              url.split('/').last.length - 20,
              url.split('/').last.length,
            )
      : url.split('/').last;

  return str;
}

({String year, String month, String day}) toJalali(
  int y,
  int m,
  int d, {
  bool twoDigits = false,
}) {
  var sumMonthDay = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  var jY = 0;
  if (y > 1600) {
    jY = 979;
    y -= 1600;
  } else {
    jY = 0;
    y -= 621;
  }
  var gy = (m > 2) ? y + 1 : y;
  var day =
      (365 * y) +
      ((gy + 3) ~/ 4) -
      ((gy + 99) ~/ 100) +
      ((gy + 399) ~/ 400) -
      80 +
      d +
      sumMonthDay[m - 1];
  jY += 33 * (day.round() / 12053).floor();
  day %= 12053;
  jY += 4 * (day.round() / 1461).floor();
  day %= 1461;
  jY += ((day.round() - 1) / 365).floor();
  if (day > 365) day = ((day - 1).round() % 365);
  int jm;
  int jd;
  int days = day.toInt();
  if (days < 186) {
    jm = 1 + (days ~/ 31);
    jd = 1 + (days % 31);
  } else {
    jm = 7 + ((days - 186) ~/ 30);
    jd = 1 + (days - 186) % 30;
  }
  String monthString = twoDigits
      ? jm.toString().padLeft(2, '0')
      : jm.toString();
  String dayString = twoDigits ? jd.toString().padLeft(2, '0') : jd.toString();

  // String persionDate = "$jY/$monthString/$dayString";

  return (
    year: "$jY",
    month: monthString,
    // month: NumberUtility.getPersianMonthLetter(monthString),
    day: dayString,
  );
}
