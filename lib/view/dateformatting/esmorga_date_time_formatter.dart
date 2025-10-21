import 'package:intl/intl.dart';

abstract class EsmorgaDateTimeFormatter {
  String formatEventDate(int epochMillis);
  String formatTimeWithMillisUtcSuffix(int hour, int minute);
  String formatIsoDateTime(DateTime date, String time);
}

class DateFormatterImpl implements EsmorgaDateTimeFormatter {
  static final DateFormat _timeFormatWithMillis = DateFormat("HH:mm:ss.SSS'Z'");
  static final DateFormat _isoDateFormat = DateFormat('yyyy-MM-dd');

  @override
  String formatTimeWithMillisUtcSuffix(int hour, int minute) {
    final dateTime = DateTime(2000, 1, 1, hour, minute);
    return _timeFormatWithMillis.format(dateTime);
  }

  @override
  String formatIsoDateTime(DateTime date, String time) {
    final datePart = _isoDateFormat.format(date);
    return '${datePart}T$time';
  }

  @override
  String formatEventDate(int epochMillis) {
    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(epochMillis);

      // Get locale-specific formatters
      final mediumDateFormatter = DateFormat.yMMMd(); // Medium date format
      final shortTimeFormatter = DateFormat.jm(); // Short time format
      final dayOfWeekFormatter = DateFormat.E(); // Day of week (short)

      final dayOfWeek = dayOfWeekFormatter.format(dateTime);
      final mediumDate = mediumDateFormatter.format(dateTime);
      final shortTime = shortTimeFormatter.format(dateTime);

      return '$dayOfWeek, $mediumDate, $shortTime';
    } catch (e) {
      return DateTime.fromMillisecondsSinceEpoch(epochMillis).toIso8601String();
    }
  }
}

