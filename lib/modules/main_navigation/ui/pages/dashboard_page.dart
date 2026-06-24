import '../../../../utils/exports.dart';

/// Dashboard tab — factory overview and summary metrics.
class DashboardTabPage extends BaseResponsiveView {
  /// Creates [DashboardTabPage].
  const DashboardTabPage({super.key});

  @override
  Widget buildMobileWidget(BuildContext context) => _buildBody(context, 2);

  @override
  Widget buildTabletWidget(BuildContext context) => _buildBody(context, 4);

  @override
  Widget buildDesktopWidget(BuildContext context) => _buildBody(context, 4);

  Widget _buildBody(BuildContext context, int summaryColumns) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextLabelWidget(
              label: strings.welcomeDashboardKey,
              textAlign: TextAlign.start,
              style: AppStyles.instance.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Dimens.space4),
            CustomTextLabelWidget(
              label: strings.dashboardOverviewKey,
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
                DashboardSummaryCard(
                  title: strings.totalExpensesKey,
                  value: '—',
                  icon: Icons.payments_outlined,
                ),
                DashboardSummaryCard(
                  title: strings.activeLaborKey,
                  value: '—',
                  icon: Icons.groups_outlined,
                ),
                DashboardSummaryCard(
                  title: strings.materialsKey,
                  value: '—',
                  icon: Icons.inventory_2_outlined,
                ),
                DashboardSummaryCard(
                  title: strings.pendingSyncKey,
                  value: '—',
                  icon: Icons.sync_outlined,
                ),
              ],
            ),
            const SizedBox(height: Dimens.space24),
            Card(
              elevation: Dimens.elevation0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(Dimens.radius12),
                onTap: () {
                  unawaited(
                    context.router.push(const FactoryStatusOverviewRoute()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.padding16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.factory_outlined,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: Dimens.space8),
                          Expanded(
                            child: CustomTextLabelWidget(
                              label: strings.factoryStatusKey,
                              textAlign: TextAlign.start,
                              style: AppStyles.instance.textTheme.titleSmall
                                  ?.copyWith(color: colorScheme.onSurface),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.padding12,
                              vertical: Dimens.padding6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius:
                                  BorderRadius.circular(Dimens.radius20),
                            ),
                            child: CustomTextLabelWidget(
                              label: strings.operationalKey,
                              style: AppStyles.instance.textTheme.labelSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimens.space16),
                      CustomTextLabelWidget(
                        label: strings.dashboardModulesHintKey,
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimens.space24),
            CustomTextLabelWidget(
              label: strings.recentActivityKey,
              textAlign: TextAlign.start,
              style: AppStyles.instance.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Dimens.space12),
            Card(
              elevation: Dimens.elevation0,
              color: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius12),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.space24),
                  child: CustomTextLabelWidget(
                    label: strings.noRecentActivityKey,
                    style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
