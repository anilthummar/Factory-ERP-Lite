import '../../../../utils/exports.dart';

/// Monthly summary report screen (UI only).
@RoutePage()
class MonthlySummaryReportPage extends StatelessWidget {
  /// Creates [MonthlySummaryReportPage].
  const MonthlySummaryReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ReportScreenShell(
      pageTitle: strings.monthlySummaryKey,
      searchHint: strings.searchReportsKey,
      filterConfig: ReportFilterUiConfig.monthly(strings),
      onExportPdf: () => runReportPdfExport(
        context,
        exportAction: getIt<ExportMonthlySummaryPdfUseCase>().call,
      ),
      onExportExcel: () => runReportExcelExport(
        context,
        exportAction: getIt<ExportMonthlySummaryExcelUseCase>().call,
      ),
      summaryCards: <ReportSummaryCard>[
        ReportSummaryCard(
          title: strings.totalExpensesKey,
          value: '—',
          icon: Icons.payments_outlined,
        ),
        ReportSummaryCard(
          title: strings.activeLaborKey,
          value: '—',
          icon: Icons.groups_outlined,
        ),
        ReportSummaryCard(
          title: strings.materialsKey,
          value: '—',
          icon: Icons.inventory_2_outlined,
        ),
        ReportSummaryCard(
          title: strings.pendingSyncKey,
          value: '—',
          icon: Icons.sync_outlined,
        ),
      ],
    );
  }
}
