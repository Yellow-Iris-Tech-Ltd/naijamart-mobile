

import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  // Parse the DateTime object from the string
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format the date using a desired format pattern
  String formattedDate = DateFormat('yMMMMEEEEd').format(dateTime); // Adjust the format as needed

  // Format the time using a desired format pattern (optional)
  String formattedTime = DateFormat('h:mm a').format(dateTime); // Adjust the format as needed (e.g., 24-hour format)

  // Choose how to display date and time (combine or separate)
  return '$formattedDate'; // Display only date
  // return '$formattedDate $formattedTime'; // Display both date and time
}