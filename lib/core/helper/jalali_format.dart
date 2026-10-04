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

/// Converts every Latin digit in [input] to a Persian digit.
String faDigits(Object? input) => toPersianDigits('${input ?? ''}');

/// Formats an amount with Persian digits and thousands separators,
/// e.g. `۴۵۰٬۰۰۰`. Pass [unit] to append a unit such as `تومان`.
String formatPrice(num amount, {String? unit}) {
  final digits = amount.round().abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write('٬');
    buf.write(digits[i]);
  }
  final sign = amount < 0 ? '-' : '';
  final text = toPersianDigits('$sign$buf');
  return unit == null ? text : '$text $unit';
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

String formatRelativeFa(String? rfc3339) {
  if (rfc3339 == null || rfc3339.isEmpty) return '';
  try {
    final dt = DateTime.parse(rfc3339).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'همین الان';
    if (diff.inHours < 1) {
      return '${toPersianDigits(diff.inMinutes.toString())} دقیقه پیش';
    }
    if (diff.inHours < 24 && now.day == dt.day) return 'امروز';
    if (diff.inHours < 48) return 'دیروز';
    if (diff.inDays < 7) {
      return '${toPersianDigits(diff.inDays.toString())} روز پیش';
    }
    final jalali = Jalali.fromDateTime(dt);
    return '${toPersianDigits(jalali.day.toString())} ${_jalaliMonths[jalali.month - 1]}';
  } catch (_) {
    return '';
  }
}

String htmlExcerpt(String? html, {int maxChars = 90}) {
  if (html == null || html.isEmpty) return '';
  final text = html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (text.length <= maxChars) return text;
  return '${text.substring(0, maxChars)}…';
}
