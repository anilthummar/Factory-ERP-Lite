import 'exports.dart';

/// Utility class for regular expressions used in the application.
class RegExpressions {
  /// The instance of the [RegExpressions].
  static RegExpressions instance = getIt<RegExpressions>();

  /// Regular expression for validating passwords.
  ///
  /// Ensures the password contains at least one letter and one number,
  /// and is at least 8 characters long.
  final RegExp password = RegExp(r'^(?=.*[a-z])(?=.*\d)[a-zA-Z\d\w\W]{8,}$');

  /// Regular expression for validating Aadhar numbers.
  ///
  /// Matches the pattern of a valid Aadhar number in India.
  final RegExp aadharRegex = RegExp(r"^[2-9]{1}[0-9]{3}\s[0-9]{4}\s[0-9]{4}$");

  /// Regular expression for matching only digits.
  ///
  /// Matches any single digit from 0 to 9.
  final RegExp onlyDigitsRegex = RegExp(r"[0-9]");

  /// Regular expression for validating email addresses.
  ///
  /// Matches the general pattern of an email address.
  final RegExp email = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
}
