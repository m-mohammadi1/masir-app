import 'number_extension.dart';

extension PriceExtensionDouble on double? {
  String get toPriceEN =>
      '$this'.replaceAllMapped(_priceReg, _mathFunc).toEnglishNumber;

  String get toPriceFA =>
      '$this'.replaceAllMapped(_priceReg, _mathFunc).toPersianNumber;
}

extension PriceExtensionNum on num? {
  String get toPriceEN =>
      '$this'.replaceAllMapped(_priceReg, _mathFunc).toEnglishNumber;

  String get toPriceFA =>
      '$this'.replaceAllMapped(_priceReg, _mathFunc).toPersianNumber;
}

extension PriceExtensionInt on int? {
  String get toPriceEN =>
      '$this'.replaceAllMapped(_priceReg, _mathFunc).toEnglishNumber;

  String get toPriceFA =>
      '$this'.replaceAllMapped(_priceReg, _mathFunc).toPersianNumber;
}

extension PriceExtensionString on String? {
  String get toPriceEN =>
      '$this'.replaceAllMapped(_priceReg, _mathFunc).toEnglishNumber;

  String get toPriceFA =>
      '$this'.replaceAllMapped(_priceReg, _mathFunc).toPersianNumber;
}

final RegExp _priceReg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String Function(Match) _mathFunc = (match) => '${match[1]},';
