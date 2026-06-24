import '../../../../utils/exports.dart';

/// Recurring expense billing frequency (UI only).
enum RecurringExpenseFrequency {
  /// Daily recurrence.
  daily,

  /// Weekly recurrence.
  weekly,

  /// Monthly recurrence.
  monthly,

  /// Yearly recurrence.
  yearly,
}

/// Localized labels for [RecurringExpenseFrequency].
extension RecurringExpenseFrequencyLabels on RecurringExpenseFrequency {
  /// Returns the localized display label.
  String label(AppString strings) {
    switch (this) {
      case RecurringExpenseFrequency.daily:
        return strings.frequencyDailyKey;
      case RecurringExpenseFrequency.weekly:
        return strings.frequencyWeeklyKey;
      case RecurringExpenseFrequency.monthly:
        return strings.frequencyMonthlyKey;
      case RecurringExpenseFrequency.yearly:
        return strings.frequencyYearlyKey;
    }
  }
}

/// All supported frequency values for dropdowns.
const List<RecurringExpenseFrequency> kRecurringExpenseFrequencies =
    <RecurringExpenseFrequency>[
  RecurringExpenseFrequency.daily,
  RecurringExpenseFrequency.weekly,
  RecurringExpenseFrequency.monthly,
  RecurringExpenseFrequency.yearly,
];
