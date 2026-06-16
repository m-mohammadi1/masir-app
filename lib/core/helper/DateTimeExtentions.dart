import '/core/helper/helper_extension.dart';
import 'package:intl/intl.dart';

extension DateTimeExtentions on DateTime {
  String formatDate() => DateFormat.yMEd("fa").format(this);

  String formatDateWithoutDay() {
    DateTime time = (this).toUtc();
    time = time.toLocal();
    var temp =
        "${DateFormat.yMd("fa").format(time)} ${DateFormat.Hms("en").format(time)}";
    return temp.fixNumberToEnglish;
  }

  String formatFullDate() {
    DateTime time = (this).toUtc();
    time = time.toLocal();
    var temp =
        "${DateFormat.yMEd("fa").format(this)} ${DateFormat.Hm("fa").format(this)}";
    return temp.fixNumberToEnglish;
  }

  String formatDateWithTime() => DateFormat.yMEd("fa").add_Hms().format(this);

  int differenceWithDayCount(DateTime date) {
    return difference(date).inDays;
  }
}
