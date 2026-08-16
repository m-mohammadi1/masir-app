import 'package:persian_datetime_picker/persian_datetime_picker.dart';

const _persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

const _jalaliMonths = [
  'فروردین',
  'اردیبهشت',
  'خرداد',
  'تیر',
  'مرداد',
  'شهریور',
  'مهر',
  'آبان',
  'آذر',
  'دی',
  'بهمن',
  'اسفند',
];

String toPersianDigits(String input) {
  return input.split('').map((c) {
    if (RegExp(r'[0-9]').hasMatch(c)) {
      return _persianDigits[int.parse(c)];
    }
    return c;
  }).join();
}

String formatMemberSince(String? rfc3339) {
  if (rfc3339 == null || rfc3339.isEmpty) return '';
  try {
    final jalali = Jalali.fromDateTime(DateTime.parse(rfc3339));
    final month = _jalaliMonths[jalali.month - 1];
    return 'عضو از $month ${toPersianDigits(jalali.year.toString())}';
  } catch (_) {
    return '';
  }
}

String formatProgressPercent(int percent) {
  return '${toPersianDigits(percent.toString())}٪';
}
