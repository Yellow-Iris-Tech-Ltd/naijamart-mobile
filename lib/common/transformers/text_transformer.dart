

import 'package:intl/intl.dart';

String transformDateTime(String inputDateTimeString) {
  // Parse the input string into a DateTime object
  DateTime inputDateTime = DateTime.parse(inputDateTimeString);

  // Format the DateTime object according to the desired format
  // String formattedDateTime = DateFormat("MMM d ${_getDaySuffix(inputDateTime.day)}, yy:H:mm:ss").format(inputDateTime);

  String formattedDateTime = DateFormat('MMM d, yy:H:mm:ss').format(inputDateTime);
  // String formattedDateTime = DateFormat('MMM d\'${_getDayWithOrdinal(inputDateTime.day)}, yy:H:mm:ss').format(inputDateTime);

  return formattedDateTime;
}


String capitalizeFirstLetter(String word) {
  if (word.isEmpty) {
    return word; // Return the input if it's an empty string
  }
  return word[0].toUpperCase() + word.substring(1);
}

String appendCountryCodeToPhoneNumber(String phoneNumber, String countryCode) {
  if (phoneNumber.isNotEmpty) {
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '$countryCode${phoneNumber.substring(1)}';
    }
  }
  return phoneNumber;
}