import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/design/design.dart';

void main() {
  test('money is written in Persian digits with separators', () {
    expect(toman(780000), '۷۸۰٬۰۰۰');
    expect(toman(0), '۰');
    expect(shortToman(240000), '۲۴۰ هزار');
    expect(shortToman(2500000), '۲٫۵ میلیون');
    expect(perMonth(210000), 'ماهی ۲۱۰ هزار');
  });

  test('durations and percentages', () {
    expect(clock(102), '۱:۴۲');
    expect(clock(5), '۰:۰۵');
    expect(approxDuration(45), '۴۵ دقیقه');
    expect(approxDuration(134), '۲ ساعت');
    expect(pct(45), '۴۵٪');
  });

  test('end dates are exact Jalali days', () {
    // 2027-01-04 is 14 Dey 1405.
    expect(jDay(DateTime(2027, 1, 4, 12)), '۱۴ دی');
    expect(jDay(DateTime(2027, 1, 4, 12), year: true), '۱۴ دی ۱۴۰۵');
  });

  test('plain() strips markup for previews', () {
    expect(plain('<p>سلام <b>دنیا</b></p>'), 'سلام دنیا');
  });

  test('unit meta shows questions for quizzes, minutes otherwise', () {
    expect(unitMeta('quiz', 0, 6), '۶ سؤال');
    expect(unitMeta('video', 7, 0), '۷ دقیقه');
    expect(unitMeta('html', 0, 0), '');
  });
}
