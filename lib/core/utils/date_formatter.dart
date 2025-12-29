import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy', 'pt_BR').format(date);
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String formatWeekday(DateTime date) {
    return DateFormat('EEEE', 'pt_BR').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, dd \'de\' MMMM \'de\' yyyy', 'pt_BR').format(date);
  }
}

