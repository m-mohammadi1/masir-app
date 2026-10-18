import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import 'tokens.dart';

const jalaliMonths = [
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
const weekdayNames = [
  'شنبه',
  'یکشنبه',
  'دوشنبه',
  'سه‌شنبه',
  'چهارشنبه',
  'پنجشنبه',
  'جمعه',
];
const weekdayLetters = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

/// Exact end dates are always written out: «تا ۲۳ دی» (never «۳ ماه دیگه»).
String jDay(DateTime d, {bool year = false}) {
  final j = Jalali.fromDateTime(d.toLocal());
  return fa('${j.day} ${jalaliMonths[j.month - 1]}${year ? ' ${j.year}' : ''}');
}

String jMonthYear(DateTime d) {
  final j = Jalali.fromDateTime(d.toLocal());
  return fa('${jalaliMonths[j.month - 1]} ${j.year}');
}

/// «پنجشنبه ۲۳ مهر».
String jWeekdayDay(DateTime d) {
  final local = d.toLocal();
  final j = Jalali.fromDateTime(local);
  return fa(
    '${weekdayNames[(local.weekday + 1) % 7]} ${j.day} ${jalaliMonths[j.month - 1]}',
  );
}

/// Toman with Persian thousands separators: «۷۸۰٬۰۰۰».
String toman(int amount) {
  final digits = amount.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) b.write('٬');
    b.write(digits[i]);
  }
  return fa(b.toString());
}

/// Short money for "ماهی ۲۶۰ هزار" / "۲٫۵ میلیون".
String shortToman(int amount) {
  if (amount >= 1000000) {
    final m = amount / 1000000;
    final s = m == m.roundToDouble()
        ? m.toStringAsFixed(0)
        : m.toStringAsFixed(1);
    return fa('${s.replaceAll('.', '٫')} میلیون');
  }
  if (amount >= 1000) return fa('${(amount / 1000).round()} هزار');
  return fa(amount);
}

String perMonth(int amount) => 'ماهی ${shortToman(amount)}';

/// «۱:۴۲» from seconds.
String clock(int seconds) {
  final m = seconds ~/ 60, s = seconds % 60;
  return fa('$m:${s.toString().padLeft(2, '0')}');
}

String minutes(int m) => fa('$m دقیقه');

/// Rough total: «۳ ساعت» / «۴۵ دقیقه».
String approxDuration(int totalMinutes) {
  if (totalMinutes >= 60) return fa('${(totalMinutes / 60).round()} ساعت');
  return minutes(totalMinutes);
}

String pct(int p) => fa('$p٪');

const _ordinals = [
  'اول', 'دوم', 'سوم', 'چهارم', 'پنجم', //
  'ششم', 'هفتم', 'هشتم', 'نهم', 'دهم',
];

/// «دوم» for 2 («تلاش دوم»); past ten, «۱۱».
String ordinal(int n) =>
    n >= 1 && n <= _ordinals.length ? _ordinals[n - 1] : fa('$n');

/// «۲ روز پیش», «امروز», «۲۰ شهریور».
String ago(DateTime? d) {
  if (d == null) return '';
  final now = DateTime.now();
  final diff = now.difference(d);
  if (diff.inMinutes < 1) return 'همین الان';
  if (diff.inHours < 1) return fa('${diff.inMinutes} دقیقه پیش');
  if (diff.inHours < 24) return fa('${diff.inHours} ساعت پیش');
  if (diff.inDays < 2) return 'دیروز';
  if (diff.inDays < 7) return fa('${diff.inDays} روز پیش');
  return jDay(d);
}

String greeting(DateTime now) {
  final h = now.hour;
  if (h < 5) return 'شب بخیر';
  if (h < 12) return 'صبح بخیر';
  if (h < 17) return 'روز بخیر';
  if (h < 20) return 'عصر بخیر';
  return 'شب بخیر';
}

const planNames = {
  'm1': 'ماهانه',
  'm3': 'سه‌ماهه',
  'm6': 'شش‌ماهه',
  'm12': 'سالانه',
};
const planEvery = {
  'm1': 'هر ماه',
  'm3': 'هر ۳ ماه',
  'm6': 'هر ۶ ماه',
  'm12': 'هر سال',
};

const levelNames = {
  'beginner': 'مقدماتی',
  'intermediate': 'متوسط',
  'advanced': 'پیشرفته',
};

const unitTypeNames = {
  'html': 'درس',
  'video': 'ویدیو',
  'audio': 'صوتی',
  'practice': 'تمرین',
  'quiz': 'آزمون',
};

/// The big complete button wording per unit type.
const unitDoneLabels = {
  'html': 'خوندم',
  'video': 'دیدم',
  'audio': 'گوش دادم',
  'practice': 'انجامش دادم',
  'quiz': 'ارسال پاسخ',
};

const unitRedoLabels = {
  'html': 'دوباره بخون',
  'video': 'دوباره ببین',
  'audio': 'دوباره گوش بده',
  'practice': 'دوباره انجام بده',
  'quiz': 'دوباره آزمون بده',
};

String unitMeta(String type, int duration, int questions) {
  if (type == 'quiz' && questions > 0) return fa('$questions سؤال');
  if (duration > 0) return minutes(duration);
  return '';
}

/// Strips HTML for previews.
String plain(String html, {int max = 160}) {
  final t = html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return t.length <= max ? t : '${t.substring(0, max)}…';
}
