import 'package:intl/intl.dart';

extension DateFormatter on String {
  String toReadableDate() {
    try {
      DateTime date = DateTime.parse(this);
      return DateFormat('MMMM d, y').format(date); // Example: March 16, 2021
    } catch (e) {
      return this; // Return the original string if parsing fails
    }
  }
}
