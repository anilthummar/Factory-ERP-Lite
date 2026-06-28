import 'package:flutter/services.dart';

/// Shared validators and input formatters for ERP forms.
abstract final class FormInputUtils {
  /// Allows up to two decimal places for currency/amount fields.
  static final List<TextInputFormatter> decimalAmountFormatters =
      <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
  ];

  /// Returns [message] when [value] is null or blank.
  static String? validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validates a positive decimal amount.
  static String? validateAmount(
    String? value, {
    required String requiredMessage,
    required String invalidMessage,
  }) {
    final String? requiredError = validateRequired(value, requiredMessage);
    if (requiredError != null) {
      return requiredError;
    }

    final double? amount = double.tryParse(value!.trim());
    if (amount == null || amount <= 0) {
      return invalidMessage;
    }

    return null;
  }
}
