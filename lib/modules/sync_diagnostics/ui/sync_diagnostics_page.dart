import '../../../../utils/exports.dart';

import '../../../../service/firebase/domain/firebase_health_check_result.dart';

/// Hidden developer screen for inspecting offline sync health.
@RoutePage()
class SyncDiagnosticsPage extends StatelessWidget {
  /// Creates [SyncDiagnosticsPage].
  const SyncDiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SyncDiagnosticsBloc>(
      create: (BuildContext context) => SyncDiagnosticsBloc(
        getSyncDiagnosticsUseCase: getIt<GetSyncDiagnosticsUseCase>(),
        retrySyncUseCase: getIt<RetrySyncUseCase>(),
      ),
      child: const _SyncDiagnosticsView(),
    );
  }
}

class _SyncDiagnosticsView extends StatelessWidget {
  const _SyncDiagnosticsView();

  String _connectivityLabel(
    AppString strings,
    SyncDiagnosticsData data,
  ) {
    if (data.isOnline) {
      return strings.syncDiagnosticsOnlineKey;
    }
    return switch (data.connectivityStatus) {
      ConnectivityResult.wifi => strings.syncDiagnosticsOfflineKey,
      ConnectivityResult.mobile => strings.syncDiagnosticsOfflineKey,
      ConnectivityResult.ethernet => strings.syncDiagnosticsOfflineKey,
      ConnectivityResult.bluetooth => strings.syncDiagnosticsBluetoothKey,
      ConnectivityResult.vpn => strings.syncDiagnosticsVpnKey,
      ConnectivityResult.other => strings.syncDiagnosticsOfflineKey,
      ConnectivityResult.none => strings.syncDiagnosticsOfflineKey,
    };
  }

  String _firebaseStatusLabel(
    AppString strings,
    FirebaseHealthCheckResult health,
  ) {
    return health.isFirebaseInitialized
        ? strings.syncDiagnosticsStatusOkKey
        : strings.syncDiagnosticsStatusFailedKey;
  }

  String _authStatusLabel(
    AppString strings,
    FirebaseHealthCheckResult health,
  ) {
    if (!health.isFirebaseInitialized) {
      return strings.syncDiagnosticsStatusFailedKey;
    }
    if (!health.isAuthenticated) {
      return strings.syncDiagnosticsStatusNotSignedInKey;
    }
    return health.userEmail ?? strings.syncDiagnosticsStatusOkKey;
  }

  String _firestoreStatusLabel(
    AppString strings,
    FirebaseHealthCheckResult health,
  ) {
    if (!health.isOnline || !health.isAuthenticated) {
      return strings.syncDiagnosticsStatusSkippedOfflineKey;
    }
    if (health.canReadFirestore && health.canWriteFirestore) {
      return strings.syncDiagnosticsStatusOkKey;
    }
    return health.firestoreWriteError ??
        health.firestoreReadError ??
        strings.syncDiagnosticsStatusFailedKey;
  }

  String _storageStatusLabel(
    AppString strings,
    FirebaseHealthCheckResult health,
  ) {
    if (!health.isOnline || !health.isAuthenticated) {
      return strings.syncDiagnosticsStatusSkippedOfflineKey;
    }
    return health.canAccessStorage
        ? strings.syncDiagnosticsStatusOkKey
        : health.storageError ?? strings.syncDiagnosticsStatusFailedKey;
  }

  Color? _statusColor(
    ColorScheme colorScheme, {
    required bool isHealthy,
    required bool isSkipped,
  }) {
    if (isSkipped) {
      return colorScheme.onSurfaceVariant;
    }
    return isHealthy ? colorScheme.primary : colorScheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.syncDiagnosticsTitleKey,
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context
                  .read<SyncDiagnosticsBloc>()
                  .add(const SyncDiagnosticsLoadRequested());
            },
            icon: const Icon(Icons.refresh_outlined),
            tooltip: strings.syncDiagnosticsRefreshKey,
          ),
        ],
      ),
      body: BlocBuilder<SyncDiagnosticsBloc, SyncDiagnosticsState>(
        builder: (BuildContext context, SyncDiagnosticsState state) {
          final bool isBusy = state.status == SyncDiagnosticsStatus.loading ||
              state.status == SyncDiagnosticsStatus.retrying;
          final SyncDiagnosticsData? data = state.data;
          final FirebaseHealthCheckResult? health = data?.firebaseHealth;

          if (state.status == SyncDiagnosticsStatus.loading && data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomResponsiveContent(
            child: ListView(
              padding: const EdgeInsets.all(Dimens.padding16),
              children: <Widget>[
                if (state.status == SyncDiagnosticsStatus.failure) ...<Widget>[
                  Card(
                    color: colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.padding16),
                      child: CustomTextLabelWidget(
                        label: state.errorMessage ??
                            strings.somethingWentWrongKey,
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.onErrorContainer),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimens.space16),
                ],
                _DiagnosticsMetricCard(
                  title: strings.syncDiagnosticsFirebaseStatusKey,
                  value: health == null
                      ? '—'
                      : _firebaseStatusLabel(strings, health),
                  icon: Icons.local_fire_department_outlined,
                  valueColor: health == null
                      ? null
                      : _statusColor(
                          colorScheme,
                          isHealthy: health.isFirebaseInitialized,
                          isSkipped: false,
                        ),
                ),
                const SizedBox(height: Dimens.space12),
                _DiagnosticsMetricCard(
                  title: strings.syncDiagnosticsAuthStatusKey,
                  value: health == null
                      ? '—'
                      : _authStatusLabel(strings, health),
                  icon: Icons.verified_user_outlined,
                  valueColor: health == null
                      ? null
                      : _statusColor(
                          colorScheme,
                          isHealthy: health.isAuthenticated,
                          isSkipped: false,
                        ),
                ),
                const SizedBox(height: Dimens.space12),
                _DiagnosticsMetricCard(
                  title: strings.syncDiagnosticsFirestoreStatusKey,
                  value: health == null
                      ? '—'
                      : _firestoreStatusLabel(strings, health),
                  icon: Icons.cloud_outlined,
                  valueColor: health == null
                      ? null
                      : _statusColor(
                          colorScheme,
                          isHealthy:
                              health.canReadFirestore && health.canWriteFirestore,
                          isSkipped:
                              !health.isOnline || !health.isAuthenticated,
                        ),
                ),
                const SizedBox(height: Dimens.space12),
                _DiagnosticsMetricCard(
                  title: strings.syncDiagnosticsStorageStatusKey,
                  value: health == null
                      ? '—'
                      : _storageStatusLabel(strings, health),
                  icon: Icons.storage_outlined,
                  valueColor: health == null
                      ? null
                      : _statusColor(
                          colorScheme,
                          isHealthy: health.canAccessStorage,
                          isSkipped:
                              !health.isOnline || !health.isAuthenticated,
                        ),
                ),
                const SizedBox(height: Dimens.space24),
                _DiagnosticsMetricCard(
                  title: strings.syncDiagnosticsPendingQueueKey,
                  value: '${data?.pendingQueueCount ?? 0}',
                  icon: Icons.pending_actions_outlined,
                ),
                const SizedBox(height: Dimens.space12),
                _DiagnosticsMetricCard(
                  title: strings.syncDiagnosticsFailedQueueKey,
                  value: '${data?.failedQueueCount ?? 0}',
                  icon: Icons.error_outline,
                  valueColor: (data?.failedQueueCount ?? 0) > 0
                      ? colorScheme.error
                      : null,
                ),
                const SizedBox(height: Dimens.space12),
                _DiagnosticsMetricCard(
                  title: strings.lastSyncTimeKey,
                  value: data?.lastSyncAt == null
                      ? strings.neverSyncedKey
                      : dateToString(
                          data!.lastSyncAt!,
                          dateFormat: DateConstants.dateTimeFormat,
                        ),
                  icon: Icons.cloud_done_outlined,
                ),
                const SizedBox(height: Dimens.space12),
                _DiagnosticsMetricCard(
                  title: strings.syncDiagnosticsConnectivityKey,
                  value: data == null
                      ? '—'
                      : _connectivityLabel(strings, data),
                  icon: data?.isOnline ?? false
                      ? Icons.wifi
                      : Icons.wifi_off_outlined,
                  valueColor: data?.isOnline ?? false
                      ? colorScheme.primary
                      : colorScheme.error,
                ),
                const SizedBox(height: Dimens.space32),
                CustomButtonWidget(
                  text: strings.syncDiagnosticsRetryKey,
                  backgroundColor: colorScheme.primary,
                  onClick: isBusy
                      ? null
                      : () {
                          context.read<SyncDiagnosticsBloc>().add(
                                const SyncDiagnosticsRetryRequested(),
                              );
                        },
                  textStyle:
                      AppStyles.instance.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                if (isBusy) ...<Widget>[
                  const SizedBox(height: Dimens.space16),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DiagnosticsMetricCard extends StatelessWidget {
  const _DiagnosticsMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Card(
      elevation: Dimens.elevation0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding16),
        child: Row(
          children: <Widget>[
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: Dimens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextLabelWidget(
                    label: title,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Dimens.space4),
                  CustomTextLabelWidget(
                    label: value,
                    textAlign: TextAlign.start,
                    style:
                        AppStyles.instance.textTheme.titleMedium?.copyWith(
                      color: valueColor ?? colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
