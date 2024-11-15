

import 'package:nb_utils/nb_utils.dart';

bool validateNigeriaPhoneNumber(String phoneNumber) {
  final pattern = RegExp(r'^0[789]\d{9}$');
  return pattern.hasMatch(phoneNumber);
}

bool validatePhoneNumber(String phoneNumber) {
  final pattern = RegExp(r'^\d{10,15}$');
  return pattern.hasMatch(phoneNumber);
}

String convertPhoneNumber(String phoneNumber, String countryCode) {
  if (phoneNumber.isNotEmpty) {
    if (phoneNumber.startsWith('0')) {
      // Remove the leading '0' and add '+234' to the beginning.
      phoneNumber = '$countryCode${phoneNumber.substring(1)}';
    }
  }
  return '$countryCode$phoneNumber';
}

String formatNumber(String input, int precision) {
  // Parse the input string to a double
  double parsedNumber = double.tryParse(input) ?? 0.0;

  // Round the number to the specified precision
  double roundedNumber = double.parse(parsedNumber.toStringAsFixed(precision));

  // Convert the rounded number back to a string
  String formattedNumber = roundedNumber.toString();

  return formattedNumber;
}

bool isEmailAddressValid(String email) {
  // Define a regular expression pattern for a valid email address
  const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
  // Create a RegExp object with the pattern
  final regExp = RegExp(emailPattern);
  // Use the RegExp's hasMatch method to check if the email matches the pattern
  return regExp.hasMatch(email);
}

bool isValidBVN(String bvn) {
  // Check if the BVN is a non-null string with exactly 11 digits
  if (bvn != null && bvn.length == 11) {
    // Check if all characters in the BVN are digits
    if (bvn.split('').every((char) => char.isDigit())) {
      return true; // Valid BVN
    }
  }
  return false; // Invalid BVN
}

bool arePasswordsValid(String password, String repeatPassword) {
  if (password.length >= 8 && password == repeatPassword) {
    return true;
  } else {
    return false;
  }
}

bool checkOtpValidity(String otpPara) {
  if (otpPara == null) {
    return false;
  }
  // Use a regular expression to check if the OTP contains exactly 6 digits.
  RegExp regex = RegExp(r'^\d{6}$');
  return regex.hasMatch(otpPara);
  // return true;
}

bool checkPinValidity(String otpPara) {
  if (otpPara == null) {
    return false;
  }
  // Use a regular expression to check if the OTP contains exactly 4 digits.
  RegExp regex = RegExp(r'^\d{4}$');
  return regex.hasMatch(otpPara);
  // return true;
}

bool validateUsername(String username) {
  if (username.isEmpty) {
    return false; // Username is empty
  }

  final usernameRegex = RegExp(r"^[a-zA-Z0-9][a-zA-Z0-9_.]{2,19}$");

  if (!usernameRegex.hasMatch(username)) {
    return false; // Username doesn't match the allowed pattern
  }

  return true; // Username is valid
}

bool checkIfPositive(int? number) {
  if (number != null && number > 0) {
    return true;
  } else {
    return false;
  }
}