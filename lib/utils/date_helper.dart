import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static String monthKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

  static String currentMonthKey() => monthKey(DateTime.now());

  static String monthLabel(DateTime d) => DateFormat('MMM yyyy').format(d);

  static String dayHeader(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(d.year, d.month, d.day);
    final diff = today.difference(that).inDays;
    if (diff == 0) return 'today'.tr;
    if (diff == 1) return 'yesterday'.tr;
    return DateFormat('EEE, MMM d').format(d);
  }

  static String friendlyDate(DateTime d) => DateFormat('EEE, MMM d, yyyy').format(d);

  static String timeOfDayGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'greeting_morning'.tr;
    if (h < 18) return 'greeting_afternoon'.tr;
    return 'greeting_evening'.tr;
  }
}
