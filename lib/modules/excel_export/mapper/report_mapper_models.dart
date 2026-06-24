/// Label/value pair for summary sheets.
class SummaryMetricRow {
  /// Creates [SummaryMetricRow].
  const SummaryMetricRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

/// Category aggregate row for expense reports.
class CategoryAmountRow {
  /// Creates [CategoryAmountRow].
  const CategoryAmountRow({
    required this.category,
    required this.amount,
    required this.recordCount,
  });

  final String category;
  final double amount;
  final int recordCount;
}

/// Expense detail row for Excel export.
class ExpenseDetailRow {
  /// Creates [ExpenseDetailRow].
  const ExpenseDetailRow({
    required this.date,
    required this.title,
    required this.category,
    required this.amount,
    required this.notes,
  });

  final DateTime date;
  final String title;
  final String category;
  final double amount;
  final String notes;
}

/// Mapped expense report data for workbook generation.
class ExpenseReportMappedData {
  /// Creates [ExpenseReportMappedData].
  const ExpenseReportMappedData({
    required this.generatedAt,
    required this.summary,
    required this.categoryBreakdown,
    required this.details,
  });

  final DateTime generatedAt;
  final List<SummaryMetricRow> summary;
  final List<CategoryAmountRow> categoryBreakdown;
  final List<ExpenseDetailRow> details;
}

/// Labor detail row for Excel export.
class LaborDetailRow {
  /// Creates [LaborDetailRow].
  const LaborDetailRow({
    required this.name,
    required this.skill,
    required this.mobile,
    required this.dailyWage,
    required this.notes,
  });

  final String name;
  final String skill;
  final String mobile;
  final double dailyWage;
  final String notes;
}

/// Mapped labor report data for workbook generation.
class LaborReportMappedData {
  /// Creates [LaborReportMappedData].
  const LaborReportMappedData({
    required this.generatedAt,
    required this.summary,
    required this.details,
  });

  final DateTime generatedAt;
  final List<SummaryMetricRow> summary;
  final List<LaborDetailRow> details;
}

/// Person detail row for Excel export.
class PersonDetailRow {
  /// Creates [PersonDetailRow].
  const PersonDetailRow({
    required this.name,
    required this.mobile,
    required this.address,
    required this.notes,
  });

  final String name;
  final String mobile;
  final String address;
  final String notes;
}

/// Mapped person report data for workbook generation.
class PersonReportMappedData {
  /// Creates [PersonReportMappedData].
  const PersonReportMappedData({
    required this.generatedAt,
    required this.summary,
    required this.details,
  });

  final DateTime generatedAt;
  final List<SummaryMetricRow> summary;
  final List<PersonDetailRow> details;
}

/// Mapped monthly summary data for workbook generation.
class MonthlySummaryMappedData {
  /// Creates [MonthlySummaryMappedData].
  const MonthlySummaryMappedData({
    required this.generatedAt,
    required this.monthLabel,
    required this.summary,
    required this.categoryBreakdown,
    required this.monthExpenses,
  });

  final DateTime generatedAt;
  final String monthLabel;
  final List<SummaryMetricRow> summary;
  final List<CategoryAmountRow> categoryBreakdown;
  final List<ExpenseDetailRow> monthExpenses;
}
