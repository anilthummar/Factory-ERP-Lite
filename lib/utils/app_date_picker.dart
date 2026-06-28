import 'package:flutter/material.dart';

import 'date_utils.dart';

/// Shows a Material date picker and returns the selected [DateTime].
Future<DateTime?> pickAppDate(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final DateTime now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? now,
    firstDate: firstDate ?? DateTime(now.year - 10),
    lastDate: lastDate ?? DateTime(now.year + 10),
  );
}

/// Opens a date picker and writes the formatted value into [controller].
Future<void> pickAppDateIntoController(
  BuildContext context,
  TextEditingController controller, {
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  DateTime initialDate = DateTime.now();
  if (controller.text.trim().isNotEmpty) {
    initialDate = stringToDate(controller.text.trim());
  }

  final DateTime? picked = await pickAppDate(
    context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (picked != null) {
    controller.text = dateToString(picked);
  }
}
