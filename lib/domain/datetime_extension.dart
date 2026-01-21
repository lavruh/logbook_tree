import 'package:intl/intl.dart';

extension CompareDateTo on DateTime {
  int compareDateTo(DateTime b) {
    if (millisecondsSinceEpoch == b.millisecondsSinceEpoch) return 0;
    if (millisecondsSinceEpoch > b.millisecondsSinceEpoch) return 1;
    if (millisecondsSinceEpoch < b.millisecondsSinceEpoch) return -1;
    return 0;
  }
}

extension IsSameDate on DateTime {
  bool isSameDate(DateTime b) {
    return year == b.year && month == b.month && day == b.day;
  }

  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  int weekNumber() {
    int dayOfYear = int.parse(DateFormat("D").format(this));
    int woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(year - 1);
    } else if (woy > numOfWeeks(year)) {
      woy = 1;
    }
    return woy;
  }
}
