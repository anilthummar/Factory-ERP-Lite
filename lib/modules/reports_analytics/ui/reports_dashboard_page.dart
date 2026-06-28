import '../../../../utils/exports.dart';

/// Data for a report type tile on the dashboard grid.
class ReportTypeItem {
  /// Creates [ReportTypeItem].
  const ReportTypeItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  /// Report type title.
  final String title;

  /// Report type icon.
  final IconData icon;

  /// Navigation callback placeholder.
  final VoidCallback onTap;
}

/// Reports dashboard with navigation to report types (UI only).
class ReportsDashboardPage extends BaseResponsiveView {
  /// Creates [ReportsDashboardPage].
  const ReportsDashboardPage({super.key});

  @override
  Widget buildMobileWidget(BuildContext context) => _buildBody(context, 2);

  @override
  Widget buildTabletWidget(BuildContext context) => _buildBody(context, 3);

  @override
  Widget buildDesktopWidget(BuildContext context) => _buildBody(context, 4);

  List<ReportTypeItem> _reportTypes(BuildContext context) {
    final AppString strings = context.appString;

    return <ReportTypeItem>[
      ReportTypeItem(
        title: strings.expenseReportsKey,
        icon: Icons.payments_outlined,
        onTap: () {
          unawaited(context.router.push(const ExpenseReportRoute()));
        },
      ),
      ReportTypeItem(
        title: strings.laborReportsKey,
        icon: Icons.engineering_outlined,
        onTap: () {
          unawaited(context.router.push(const LaborReportRoute()));
        },
      ),
      ReportTypeItem(
        title: strings.personReportsKey,
        icon: Icons.person_outline,
        onTap: () {
          unawaited(context.router.push(const PersonReportRoute()));
        },
      ),
      ReportTypeItem(
        title: strings.monthlySummaryKey,
        icon: Icons.summarize_outlined,
        onTap: () {
          unawaited(context.router.push(const MonthlySummaryReportRoute()));
        },
      ),
    ];
  }

  Widget _buildBody(BuildContext context, int crossAxisCount) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;
    final List<ReportTypeItem> reportTypes = _reportTypes(context);
    final int summaryColumns = context.isMobileView ? 2 : 4;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.navReportsKey,
          textAlign: TextAlign.start,
        ),
      ),
      body: CustomResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.all(Dimens.padding16),
          children: <Widget>[
            CustomTextLabelWidget(
              label: strings.reportsDashboardSubtitleKey,
              textAlign: TextAlign.start,
              style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Dimens.space24),
            GridView.count(
              crossAxisCount: summaryColumns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: Dimens.space12,
              mainAxisSpacing: Dimens.space12,
              childAspectRatio: 1.35,
              children: <Widget>[
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
            ),
            const SizedBox(height: Dimens.space24),
            CustomTextLabelWidget(
              label: strings.reportsPageKey,
              textAlign: TextAlign.start,
              style: AppStyles.instance.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Dimens.space12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: Dimens.space12,
                mainAxisSpacing: Dimens.space12,
                childAspectRatio: 0.95,
              ),
              itemCount: reportTypes.length,
              itemBuilder: (BuildContext context, int index) {
                final ReportTypeItem item = reportTypes[index];

                return EntryModuleCard(
                  title: item.title,
                  icon: item.icon,
                  onTap: item.onTap,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
