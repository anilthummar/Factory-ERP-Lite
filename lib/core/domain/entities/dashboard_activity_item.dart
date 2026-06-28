import 'package:equatable/equatable.dart';

/// Source module for a dashboard recent-activity entry.
enum DashboardActivitySource {
  /// Person management record.
  person,

  /// Labor management record.
  labor,

  /// One-time expense record.
  expense,

  /// Recurring expense record.
  recurringExpense,

  /// Factory status change.
  factoryStatus,
}

/// A single recent activity shown on the dashboard.
class DashboardActivityItem extends Equatable {
  /// Creates [DashboardActivityItem].
  const DashboardActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.occurredAt,
    required this.source,
  });

  /// Record identifier.
  final String id;

  /// Primary activity label.
  final String title;

  /// Secondary context (module name, amount, etc.).
  final String subtitle;

  /// When the activity occurred.
  final DateTime occurredAt;

  /// Originating ERP module.
  final DashboardActivitySource source;

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        subtitle,
        occurredAt,
        source,
      ];
}
