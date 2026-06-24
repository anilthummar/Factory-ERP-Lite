import '../../../../utils/exports.dart';

/// Person reports screen (UI only).
@RoutePage()
class PersonReportPage extends StatelessWidget {
  /// Creates [PersonReportPage].
  const PersonReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ReportScreenShell(
      pageTitle: strings.personReportsKey,
      searchHint: strings.searchReportsKey,
      filterConfig: ReportFilterUiConfig.person(strings),
      summaryCards: <ReportSummaryCard>[
        ReportSummaryCard(
          title: strings.personManagementKey,
          value: '—',
          icon: Icons.person_outline,
        ),
        ReportSummaryCard(
          title: strings.nameKey,
          value: '—',
          icon: Icons.badge_outlined,
        ),
        ReportSummaryCard(
          title: strings.emailIdKey,
          value: '—',
          icon: Icons.phone_outlined,
        ),
        ReportSummaryCard(
          title: strings.customerAndLocationKey,
          value: '—',
          icon: Icons.location_on_outlined,
        ),
      ],
    );
  }
}
