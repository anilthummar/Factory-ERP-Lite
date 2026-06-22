import 'exports.dart';

/// Extension methods for [String] to provide additional utilities.
extension StringUtils on String? {
  /// Checks if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Checks if the string is not null or empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Checks if the string is blank (null or only whitespace).
  bool get isBlank => this == null || this!.trim().isEmpty;

  /// Checks if the string is a valid employee code.
  bool get isValidEmployeeCode =>
      this!.toString().toLowerCase().startsWith("c");

  /// Checks if the string is not blank.
  bool get isNotBlank => !isBlank;

  /// Checks if the string is null or blank.
  bool get isNullOrBlank => this == null || isBlank;

  /// Checks if the string is not null or blank.
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Checks if the string is a valid password.
  bool get isValidPassword =>
      RegExpressions.instance.password.hasMatch(this ?? '');

  /// Converts the string to title case.
  String get toTitleCase =>
      this == null ? '' : '${this![0].toUpperCase()}${this!.substring(1)}';

  /// Encodes the string to Base64.
  String get toBase64 => base64Encode(utf8.encode(this ?? ''));

  /// Decodes the string from Base64.
  Uint8List get fromBase64 => base64Decode(this ?? '');
}

/// Extension methods for [List<String>] to provide additional utilities.
extension ListUtil on List<String> {
  /// Joins the list of strings into a single string with commas.
  String get joinToString =>
      reduce((String curr, String next) => '$curr,$next');

  /// Joins the list of strings into a single string without commas.
  String get joinToWithOutComaString =>
      reduce((String curr, String next) => '$curr$next');
}

/// Extension methods for validation of text fields.
///
/// Includes email validation, mobile number validation, password validation,
/// confirm password validation, and collection code validation.
extension TextFieldValidator on String {
  /// Validates the password field.
  /// Checks if it is not empty and matches the regex for password.
  String? validatePassword(BuildContext context) {
    if (isEmpty) {
      return context.appString.pleaseEnterPasswordKey;
    } else if (!RegExpressions.instance.password.hasMatch(this)) {
      return context.appString.passwordShouldHaveKey;
    } else {
      return null;
    }
  }

  /// Validates the email field.
  String? validateEmail(BuildContext context) {
    if (isEmpty) {
      return context.appString.pleaseEnterEmailIdKey;
    } else if (!RegExpressions.instance.email.hasMatch(this)) {
      return context.appString.pleaseEnterValidEmailIdKey;
    }
    return null;
  }

  /// Validates the OTP code field.
  String? validateOtpCode(BuildContext context) {
    if (isEmpty) {
      return context.appString.pleaseEnterOTPKey;
    } else if (length != AppConstant.otpTextLength) {
      return context.appString.pleaseEnterValidOTPKey;
    } else {
      return null;
    }
  }
}
