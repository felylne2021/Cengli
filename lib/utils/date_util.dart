import 'package:intl/intl.dart';

class DateUtil {
  static String formatDateTime(DateTime date, [String? format]) {
    final DateFormat dateFormat = DateFormat(format ?? 'dd MMM @ hh:mm');

    return dateFormat.format(date);
  }
}
