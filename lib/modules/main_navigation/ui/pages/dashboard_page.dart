import '../../../../core/domain/entities/dashboard_activity_item.dart';
import '../../../../core/domain/entities/dashboard_data.dart';
import '../../../../utils/exports.dart';

/// Dashboard tab — factory overview and summary metrics.
class DashboardTabPage extends StatelessWidget {
  /// Creates [DashboardTabPage].
  const DashboardTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (BuildContext context) => DashboardBloc(
        getDashboardDataUseCase: getIt<GetDashboardDataUseCase>(),
      ),
      child: const _DashboardTabView(),
    );
  }
}

class _DashboardTabView extends StatelessWidget {
  const _DashboardTabView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (BuildContext context, DashboardState state) {
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<DashboardBloc>()
                .add(const DashboardRefreshRequested());
            await context.read<DashboardBloc>().stream.firstWhere(
                  (DashboardState next) =>
                      next.status == DashboardStatus.success ||
                      next.status == DashboardStatus.failure,
                );
          },
          child: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DashboardState state) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;
    final DashboardData? data = state.data;
    final bool isLoading = state.status == DashboardStatus.loading &&
        data == null;

    final String personsValue =
        isLoading ? '—' : '${data?.totalPersons ?? 0}';
    final String laborValue = isLoading ? '—' : '${data?.totalLabor ?? 0}';
    final String expensesValue =
        isLoading ? '—' : '${data?.totalExpenses ?? 0}';
    final String pendingSyncValue =
        isLoading ? '—' : '${data?.pendingSyncCount ?? 0}';
    final String lastSyncValue = isLoading
        ? '—'
        : data?.lastSyncAt == null
            ? strings.neverSyncedKey
            : dateToString(
                data!.lastSyncAt!,
                dateFormat: DateConstants.dateTimeFormat,
              );

    final String factoryStatusLabel = data?.currentFactoryStatus == null
        ? strings.operationalKey
        : data!.currentFactoryStatus!.toUi().label(strings);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
            if (state.status == DashboardStatus.failure) ...<Widget>[
              const SizedBox(height: Dimens.space12),
              CustomTextLabelWidget(
                label: state.errorMessage ?? strings.somethingWentWrongKey,
                textAlign: TextAlign.start,
                style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: Dimens.space24),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final int columns = constraints.maxWidth >= 900
                    ? 4
                    : constraints.maxWidth >= 600
                        ? 2
                        : 2;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: Dimens.space12,
                  mainAxisSpacing: Dimens.space12,
                  childAspectRatio: 1.35,
                  children: <Widget>[
                    DashboardSummaryCard(
                      title: strings.totalPersonsKey,
                      value: personsValue,
                      icon: Icons.people_outline,
                    ),
                    DashboardSummaryCard(
                      title: strings.totalLaborKey,
                      value: laborValue,
                      icon: Icons.groups_outlined,
                    ),
                    DashboardSummaryCard(
                      title: strings.totalExpensesKey,
                      value: expensesValue,
                      icon: Icons.payments_outlined,
                    ),
                    DashboardSummaryCard(
                      title: strings.pendingSyncKey,
                      value: pendingSyncValue,
                      icon: Icons.sync_outlined,
                    ),
                    DashboardSummaryCard(
                      title: strings.lastSyncTimeKey,
                      value: lastSyncValue,
                      icon: Icons.cloud_done_outlined,
                    ),
                  ],
                );
              },
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
                              label: factoryStatusLabel,
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
                        label: data?.currentFactoryStatusNotes?.isNotEmpty ??
                                false
                            ? data!.currentFactoryStatusNotes!
                            : strings.dashboardModulesHintKey,
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
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (data == null || data.recentActivities.isEmpty)
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
              )
            else
              ...data.recentActivities.map((DashboardActivityItem activity) {
                final String timestamp = dateToString(
                  activity.occurredAt,
                  dateFormat: DateConstants.dateTimeFormat,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.space8),
                  child: Card(
                    elevation: Dimens.elevation0,
                    color: colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radius12),
                    ),
                    child: ListTile(
                      title: CustomTextLabelWidget(
                        label: activity.title,
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.bodyMedium,
                      ),
                      subtitle: CustomTextLabelWidget(
                        label: '${activity.subtitle} • $timestamp',
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
