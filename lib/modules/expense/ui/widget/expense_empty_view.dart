import '../../../../utils/exports.dart';

/// Localized copy for expense empty states.
class ExpenseEmptyUiConfig {
  /// Creates [ExpenseEmptyUiConfig].
  const ExpenseEmptyUiConfig({
    required this.title,
    required this.message,
    this.icon = Icons.receipt_long_outlined,
  });

  /// Resolves shared expense empty strings.
  factory ExpenseEmptyUiConfig.of(AppString strings) {
    return ExpenseEmptyUiConfig(
      title: strings.expenseEmptyTitleKey,
      message: strings.expenseEmptyMessageKey,
    );
  }

  /// Empty state icon.
  final IconData icon;

  /// Empty state title.
  final String title;

  /// Empty state message.
  final String message;
}

/// Reusable expense module empty state.
class ExpenseEmptyView extends StatelessWidget {
  /// Creates [ExpenseEmptyView].
  const ExpenseEmptyView({
    required this.config,
    super.key,
  });

  /// Empty state configuration.
  final ExpenseEmptyUiConfig config;

  @override
  Widget build(BuildContext context) {
    return CustomEmptyStateWidget(
      icon: config.icon,
      title: config.title,
      message: config.message,
    );
  }
}
