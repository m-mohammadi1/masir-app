import 'dart:math';

/// Shared phrases of Masir's voice: spoken, warm Persian in the second
/// person. Screen-specific strings stay inline in their widgets.
class MasirCopy {
  const MasirCopy._();

  /// Swap in a seeded [Random] in tests to pin the rotating phrases.
  static Random random = Random();

  /// "Good morning" style greeting for the time of day [now].
  static String greeting(String? name, {DateTime? now}) {
    final n = name?.trim() ?? '';
    if (n.isEmpty) return 'سلام رفیق';
    final hour = (now ?? DateTime.now()).hour;
    final String line;
    if (hour < 5) {
      return 'شب بخیر $n، هنوز بیداری؟';
    } else if (hour < 11) {
      line = 'صبح بخیر';
    } else if (hour < 16) {
      line = 'ظهرت بخیر';
    } else if (hour < 20) {
      line = 'عصر بخیر';
    } else {
      line = 'شب بخیر';
    }
    return '$line $n';
  }

  static const List<String> _cheers = [
    'ایول!',
    'دمت گرم!',
    'یکی دیگه هم تموم شد',
    'داری می‌ترکونی',
    'آفرین!',
  ];

  static const List<String> _nearMisses = [
    'چیزی نمونده بود!',
    'یه بار دیگه، این دفعه می‌شه',
    'این بار نشد، ولی نزدیکی',
  ];

  /// A short cheer for finishing a unit.
  static String cheer() => _cheers[random.nextInt(_cheers.length)];

  /// A gentle line for a quiz that was not passed.
  static String nearMiss() => _nearMisses[random.nextInt(_nearMisses.length)];

  static const String networkError =
      'اینترنتت قطعه یا ضعیفه، یه نگاه بنداز و دوباره امتحان کن';
  static const String serverError =
      'یه چیزی این وسط خراب شد، چند لحظه دیگه دوباره امتحان کن';
  static const String vpnError =
      'انگار فیلترشکنت روشنه، خاموشش کن و دوباره بیا';
  static const String retry = 'دوباره امتحان کن';
  static const String back = 'برگردیم';
}
