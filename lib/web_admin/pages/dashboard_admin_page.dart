import '../../../core/domain/entities/dashboard_activity_item.dart';
import '../../../core/domain/entities/dashboard_data.dart';
import '../../../core/domain/enums/factory_status_type.dart' as domain;
import '../../../modules/dashboard/ui/dashboard_activity_source_ui.dart';
import '../../../utils/exports.dart';
import '../widgets/admin_centered_status_panel.dart';
import '../widgets/admin_metric_card.dart';
import '../widgets/admin_simple_bar_chart.dart';

/// Web admin dashboard with live metrics, factory status, activity, and charts.
class DashboardAdminPage extends StatefulWidget {
  /// Creates [DashboardAdminPage].
  const DashboardAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  late final DashboardBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DashboardBloc(
      getDashboardDataUseCase: getIt<GetDashboardDataUseCase>(),
    );
  }

  @override
  void didUpdateWidget(covariant DashboardAdminPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshTick != widget.refreshTick) {
      _bloc.add(const DashboardRefreshRequested());
    }
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>.value(
      value: _bloc,
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (BuildContext context, DashboardState state) {
          return _DashboardBody(state: state);
        },
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppString strings = context.appString;
    final DashboardData? data = state.data;
    final bool isLoading =
        state.status == DashboardStatus.loading && data == null;

    if (isLoading) {
      return const SizedBox.expand(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == DashboardStatus.failure && data == null) {
      return AdminCenteredStatusPanel(
        icon: Icons.error_outline,
        message: state.errorMessage ?? strings.somethingWentWrongKey,
        actionLabel: strings.syncDiagnosticsRefreshKey,
        onAction: () {
          context.read<DashboardBloc>().add(const DashboardLoadRequested());
        },
      );
    }

    if (data == null) {
      return AdminCenteredStatusPanel(
        message: strings.somethingWentWrongKey,
        actionLabel: strings.syncDiagnosticsRefreshKey,
        onAction: () {
          context.read<DashboardBloc>().add(const DashboardLoadRequested());
        },
      );
    }

    final String lastSync = data.lastSyncAt == null
        ? strings.neverSyncedKey
        : dateToString(
            data.lastSyncAt!,
            dateFormat: DateConstants.dateTimeFormat,
          );

    final bool hasFactoryStatus = data.currentFactoryStatus != null;
    final String factoryStatusLabel = hasFactoryStatus
        ? data.currentFactoryStatus!.toUi().label(strings)
        : strings.noFactoryStatusSetKey;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int metricColumns = constraints.maxWidth >= 1200
            ? 4
            : constraints.maxWidth >= 800
                ? 2
                : 1;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                strings.dashboardOverviewKey,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: metricColumns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
                children: <Widget>[
                  AdminMetricCard(
                    label: strings.totalPersonsKey,
                    value: '${data.totalPersons}',
                    icon: Icons.people_outline,
                  ),
                  AdminMetricCard(
                    label: strings.totalLaborKey,
                    value: '${data.totalLabor}',
                    icon: Icons.engineering_outlined,
                  ),
                  AdminMetricCard(
                    label: strings.totalExpensesKey,
                    value: '${data.totalExpenses}',
                    icon: Icons.receipt_long_outlined,
                  ),
                  AdminMetricCard(
                    label: strings.pendingSyncKey,
                    value: '${data.pendingSyncCount}',
                    icon: Icons.sync_outlined,
                    subtitle: '${strings.lastSyncTimeKey}: $lastSync',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints inner) {
                  final bool sideBySide = inner.maxWidth >= 1000;
                  final Widget factoryCard = _FactoryStatusCard(
                    label: factoryStatusLabel,
                    notes: data.currentFactoryStatusNotes,
                    updatedAt: data.factoryStatusUpdatedAt,
                    hasStatus: hasFactoryStatus,
                  );
                  final Widget chart = AdminSimpleBarChart(
                    title: 'Records Overview',
                    entries: <AdminBarChartEntry>[
                      AdminBarChartEntry(
                        label: strings.totalPersonsKey,
                        value: data.totalPersons,
                      ),
                      AdminBarChartEntry(
                        label: strings.totalLaborKey,
                        value: data.totalLabor,
                      ),
                      AdminBarChartEntry(
                        label: strings.totalExpensesKey,
                        value: data.totalExpenses,
                      ),
                      AdminBarChartEntry(
                        label: strings.pendingSyncKey,
                        value: data.pendingSyncCount,
                      ),
                    ],
                  );

                  if (sideBySide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: factoryCard),
                        const SizedBox(width: 16),
                        Expanded(child: chart),
                      ],
                    );
                  }

                  return Column(
                    children: <Widget>[
                      factoryCard,
                      const SizedBox(height: 16),
                      chart,
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                strings.recentActivityKey,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              if (data.recentActivities.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(strings.noRecentActivityKey),
                  ),
                )
              else
                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.recentActivities.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (BuildContext context, int index) {
                      final DashboardActivityItem activity =
                          data.recentActivities[index];
                      final String timestamp = dateToString(
                        activity.occurredAt,
                        dateFormat: DateConstants.dateTimeFormat,
                      );
                      final String title =
                          activity.source == DashboardActivitySource.factoryStatus
                              ? _factoryStatusTitle(activity.title, strings)
                              : activity.title;
                      final String subtitle = activity.subtitle.isEmpty
                          ? '${activity.source.label(strings)} • $timestamp'
                          : '${activity.source.label(strings)} • ${activity.subtitle} • $timestamp';

                      return ListTile(
                        title: Text(title),
                        subtitle: Text(subtitle),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _factoryStatusTitle(String rawStatus, AppString strings) {
    try {
      return domain.FactoryStatusType.values
          .byName(rawStatus)
          .toUi()
          .label(strings);
    } on Object {
      return rawStatus;
    }
  }
}

class _FactoryStatusCard extends StatelessWidget {
  const _FactoryStatusCard({
    required this.label,
    required this.notes,
    required this.updatedAt,
    required this.hasStatus,
  });

  final String label;
  final String? notes;
  final DateTime? updatedAt;
  final bool hasStatus;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppString strings = context.appString;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.factory_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  strings.factoryStatusKey,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Chip(label: Text(label)),
              ],
            ),
            if (updatedAt != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                '${strings.lastUpdatedKey}: ${dateToString(
                  updatedAt!,
                  dateFormat: DateConstants.dateTimeFormat,
                )}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              notes?.isNotEmpty ?? false
                  ? notes!
                  : hasStatus
                      ? strings.dashboardFactoryStatusNoNotesKey
                      : strings.dashboardFactoryStatusHintKey,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
