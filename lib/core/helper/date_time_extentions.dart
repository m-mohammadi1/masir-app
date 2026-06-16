import '/core/helper/helper_extension.dart';
import 'package:intl/intl.dart';

extension DateTimeExtentions on DateTime {
  String formatDate() {
    DateTime time = (this).toUtc();
    time = time.toLocal();
    var temp = DateFormat.yMEd("fa",).format(time);
    temp.replaceAll("-", "/");
    return temp.fixNumberToEnglish;
  }

  String formatFullDate() {
    DateTime time = (this).toUtc();
    time = time.toLocal();
    var temp =
        "${DateFormat.yMEd("fa").format(time)} ساعت ${DateFormat.Hm("fa").format(time)}";
    return temp.fixNumberToEnglish;
  }

  String formatDateWithTime() {
    DateTime time = (this).toUtc();
    time = time.toLocal();
    var temp = DateFormat.yMEd("fa").add_Hms().format(time);
    return temp.fixNumberToEnglish;
  }

  int differenceWithDayCount(DateTime date) {
    return difference(date).inDays;
  }
}
