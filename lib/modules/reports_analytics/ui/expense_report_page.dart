import '../../../../utils/exports.dart';

/// Expense reports screen (UI only).
@RoutePage()
class ExpenseReportPage extends StatelessWidget {
  /// Creates [ExpenseReportPage].
  const ExpenseReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ReportScreenShell(
      pageTitle: strings.expenseReportsKey,
      searchHint: strings.searchReportsKey,
      filterConfig: ReportFilterUiConfig.expense(strings),
      summaryCards: <ReportSummaryCard>[
        ReportSummaryCard(
          title: strings.totalExpensesKey,
          value: '—',
          icon: Icons.payments_outlined,
        ),
        ReportSummaryCard(
          title: strings.materialPurchaseKey,
          value: '—',
          icon: Icons.inventory_2_outlined,
        ),
        ReportSummaryCard(
          title: strings.truckExpensesKey,
          value: '—',
          icon: Icons.local_shipping_outlined,
        ),
        ReportSummaryCard(
          title: strings.recurringExpensesKey,
          value: '—',
          icon: Icons.autorenew,
        ),
      ],
    );
  }
}
