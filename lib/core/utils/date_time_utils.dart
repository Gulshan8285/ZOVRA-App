import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM d, yyyy').format(dateTime);
  }

  static String formatMediumDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM, hh:mm a').format(dateTime);
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatMediumDate(dateTime);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static List<DateTime> getUpcomingDays(int count) {
    final now = DateTime.now();
    return List.generate(count, (index) => now.add(Duration(days: index)));
  }

  static List<String> getStandardTimeSlots() {
    return [
      '09:00 AM - 10:30 AM',
      '11:00 AM - 12:30 PM',
      '01:00 PM - 02:30 PM',
      '03:00 PM - 04:30 PM',
      '05:00 PM - 06:30 PM',
      '07:00 PM - 08:30 PM',
    ];
  }
}

