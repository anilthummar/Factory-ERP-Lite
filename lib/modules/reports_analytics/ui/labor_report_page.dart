import '../../../../utils/exports.dart';

/// Labor reports screen (UI only).
@RoutePage()
class LaborReportPage extends StatelessWidget {
  /// Creates [LaborReportPage].
  const LaborReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ReportScreenShell(
      pageTitle: strings.laborReportsKey,
      searchHint: strings.searchReportsKey,
      filterConfig: ReportFilterUiConfig.labor(strings),
      summaryCards: <ReportSummaryCard>[
        ReportSummaryCard(
          title: strings.activeLaborKey,
          value: '—',
          icon: Icons.groups_outlined,
        ),
        ReportSummaryCard(
          title: strings.laborSkillKey,
          value: '—',
          icon: Icons.engineering_outlined,
        ),
        ReportSummaryCard(
          title: strings.dailyWageKey,
          value: '—',
          icon: Icons.payments_outlined,
        ),
        ReportSummaryCard(
          title: strings.laborManagementKey,
          value: '—',
          icon: Icons.badge_outlined,
        ),
      ],
    );
  }
}
